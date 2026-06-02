import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';

import '../models/movie.dart';

enum MovieStorageMode { sqlite, noSql }

extension MovieStorageModeLabel on MovieStorageMode {
  String get label {
    switch (this) {
      case MovieStorageMode.sqlite:
        return 'SQLite';
      case MovieStorageMode.noSql:
        return 'NoSQL';
    }
  }

  String get shortLabel {
    switch (this) {
      case MovieStorageMode.sqlite:
        return 'SQL';
      case MovieStorageMode.noSql:
        return 'NoSQL';
    }
  }
}

abstract class MovieRepository {
  Future<List<Movie>> getAll();
  Future<Movie> save(Movie movie);
  Future<void> delete(int id);
}

class MovieSeed {
  static final List<Movie> initialMovies = [
    Movie(
      id: 1,
      title: 'Interstellar',
      year: 2014,
      director: 'Christopher Nolan',
      location: 'Cine',
      watchedOn: DateTime(2026, 1, 18),
    ),
    Movie(
      id: 2,
      title: 'Spider-Man: Into the Spider-Verse',
      year: 2018,
      director: 'Bob Persichetti, Peter Ramsey y Rodney Rothman',
      location: 'Casa',
      watchedOn: DateTime(2026, 2, 2),
    ),
    Movie(
      id: 3,
      title: 'La sociedad de la nieve',
      year: 2023,
      director: 'J. A. Bayona',
      location: 'Streaming',
      watchedOn: DateTime(2026, 2, 12),
    ),
    Movie(
      id: 4,
      title: 'Top Gun: Maverick',
      year: 2022,
      director: 'Joseph Kosinski',
      location: 'Cine',
      watchedOn: DateTime(2026, 3, 1),
    ),
  ];
}

class SqlMovieRepository implements MovieRepository {
  static const _databaseName = 'movie_inventory.db';
  static const _tableName = 'movies';
  Database? _database;

  void _ensureDesktopSqliteFactory() {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  }

  Future<Database> _openDatabase() async {
    _ensureDesktopSqliteFactory();
    final database = _database;
    if (database != null) {
      return database;
    }

    final databasesPath = await getDatabasesPath();
    final filePath = path.join(databasesPath, _databaseName);
    final openedDatabase = await openDatabase(
      filePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            year INTEGER NOT NULL,
            director TEXT NOT NULL,
            location TEXT NOT NULL,
            watchedOn TEXT NOT NULL
          )
        ''');
      },
    );

    _database = openedDatabase;
    await _seedIfEmpty(openedDatabase);
    return openedDatabase;
  }

  Future<void> _seedIfEmpty(Database database) async {
    final countResult = await database.rawQuery(
      'SELECT COUNT(*) AS count FROM $_tableName',
    );
    final count = Sqflite.firstIntValue(countResult) ?? 0;
    if (count > 0) {
      return;
    }

    for (final movie in MovieSeed.initialMovies) {
      await database.insert(_tableName, movie.toMap()..remove('id'));
    }
  }

  @override
  Future<List<Movie>> getAll() async {
    final database = await _openDatabase();
    final rows = await database.query(_tableName, orderBy: 'id DESC');
    return rows.map(Movie.fromMap).toList();
  }

  @override
  Future<Movie> save(Movie movie) async {
    final database = await _openDatabase();
    final payload = movie.toMap()..remove('id');

    if (movie.id == null) {
      final id = await database.insert(_tableName, payload);
      return movie.copyWith(id: id);
    }

    await database.update(
      _tableName,
      payload,
      where: 'id = ?',
      whereArgs: [movie.id],
    );
    return movie;
  }

  @override
  Future<void> delete(int id) async {
    final database = await _openDatabase();
    await database.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }
}

class HiveMovieRepository implements MovieRepository {
  static const _boxName = 'movie_inventory_box';
  static const _moviesKey = 'movies';
  static const _nextIdKey = 'nextId';
  Box? _box;

  Future<Box> _openBox() async {
    final box = _box;
    if (box != null) {
      return box;
    }

    final openedBox = await Hive.openBox(_boxName);
    _box = openedBox;
    await _seedIfEmpty(openedBox);
    return openedBox;
  }

  Future<void> _seedIfEmpty(Box box) async {
    final stored = box.get(_moviesKey);
    if (stored is List && stored.isNotEmpty) {
      return;
    }

    await box.put(
      _moviesKey,
      MovieSeed.initialMovies.map((movie) => movie.toMap()).toList(),
    );
    await box.put(_nextIdKey, MovieSeed.initialMovies.length + 1);
  }

  List<Movie> _readMovies(Box box) {
    final stored = box.get(_moviesKey);
    if (stored is! List) {
      return [];
    }

    return stored
        .whereType<Map>()
        .map((item) => Movie.fromMap(Map<String, dynamic>.from(item)))
        .toList();
  }

  @override
  Future<List<Movie>> getAll() async {
    final box = await _openBox();
    return _readMovies(box);
  }

  @override
  Future<Movie> save(Movie movie) async {
    final box = await _openBox();
    final currentMovies = _readMovies(box);

    if (movie.id == null) {
      final nextId = (box.get(_nextIdKey) as int?) ?? 1;
      final savedMovie = movie.copyWith(id: nextId);
      currentMovies.insert(0, savedMovie);
      await box.put(
        _moviesKey,
        currentMovies.map((entry) => entry.toMap()).toList(),
      );
      await box.put(_nextIdKey, nextId + 1);
      return savedMovie;
    }

    final index = currentMovies.indexWhere((entry) => entry.id == movie.id);
    final savedMovie = movie;
    if (index == -1) {
      currentMovies.insert(0, savedMovie);
    } else {
      currentMovies[index] = savedMovie;
    }

    await box.put(
      _moviesKey,
      currentMovies.map((entry) => entry.toMap()).toList(),
    );
    return savedMovie;
  }

  @override
  Future<void> delete(int id) async {
    final box = await _openBox();
    final currentMovies = _readMovies(box)
      ..removeWhere((movie) => movie.id == id);
    await box.put(
      _moviesKey,
      currentMovies.map((entry) => entry.toMap()).toList(),
    );
  }
}
