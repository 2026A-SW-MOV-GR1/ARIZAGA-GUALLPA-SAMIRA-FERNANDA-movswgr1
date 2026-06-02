import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../repositories/movie_repository.dart';
import '../widgets/movie_editor_dialog.dart';
import '../widgets/movie_tile.dart';

class MoviesInventoryScreen extends StatefulWidget {
  const MoviesInventoryScreen({super.key});

  @override
  State<MoviesInventoryScreen> createState() => _MoviesInventoryScreenState();
}

class _MoviesInventoryScreenState extends State<MoviesInventoryScreen> {
  final _sqlRepository = SqlMovieRepository();
  final _noSqlRepository = HiveMovieRepository();

  MovieStorageMode _mode = MovieStorageMode.sqlite;
  bool _loading = true;
  List<Movie> _movies = [];

  MovieRepository get _repository =>
      _mode == MovieStorageMode.sqlite ? _sqlRepository : _noSqlRepository;

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    setState(() => _loading = true);
    final movies = await _repository.getAll();
    if (!mounted) {
      return;
    }

    setState(() {
      _movies = movies;
      _loading = false;
    });
  }

  Future<void> _saveMovie(Movie movie) async {
    final isNew = movie.id == null;
    await _repository.save(movie);
    await _loadMovies();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isNew ? 'Película guardada' : 'Película actualizada'),
      ),
    );
  }

  Future<void> _deleteMovie(Movie movie) async {
    await _repository.delete(movie.id ?? 0);
    await _loadMovies();

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('"${movie.title}" eliminada del inventario')),
    );
  }

  Future<void> _openEditor({Movie? movie}) async {
    final result = await showDialog<Movie>(
      context: context,
      builder: (_) => MovieEditorDialog(movie: movie),
    );

    if (result == null) {
      return;
    }

    await _saveMovie(result);
  }

  Future<void> _switchMode(bool useNoSql) async {
    setState(() {
      _mode = useNoSql ? MovieStorageMode.noSql : MovieStorageMode.sqlite;
    });
    await _loadMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario de películas'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _mode.shortLabel,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                Switch.adaptive(
                  value: _mode == MovieStorageMode.noSql,
                  onChanged: _switchMode,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(),
        icon: const Icon(Icons.add),
        label: const Text('Nueva película'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF6F8FC), Color(0xFFEAF3FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: RefreshIndicator(
          onRefresh: _loadMovies,
          child: SafeArea(
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                    child: _HeaderCard(
                      storageLabel: _mode.label,
                      totalItems: _movies.length,
                      description:
                          'Conmuta el switch del AppBar para comparar SQLite y NoSQL en el mismo inventario.',
                    ),
                  ),
                ),
                if (_loading)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (_movies.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.movie_filter_outlined, size: 72),
                            const SizedBox(height: 12),
                            Text(
                              'No hay películas guardadas',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Agrega una película para poblar el inventario.',
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    sliver: SliverList.separated(
                      itemCount: _movies.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final movie = _movies[index];
                        return MovieTile(
                          movie: movie,
                          storageLabel: _mode.shortLabel,
                          onEdit: () => _openEditor(movie: movie),
                          onDelete: () => _confirmDelete(movie),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(Movie movie) {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar película'),
        content: Text('¿Quieres quitar "${movie.title}" del inventario?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    ).then((shouldDelete) {
      if (shouldDelete == true) {
        _deleteMovie(movie);
      }
    });
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.storageLabel,
    required this.totalItems,
    required this.description,
  });

  final String storageLabel;
  final int totalItems;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2F80ED), Color(0xFF56CCF2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 24,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bitácora de películas',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.92),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _SmallStat(label: storageLabel, value: '$totalItems'),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'El inventario cambia de origen de datos al mover el switch superior.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withOpacity(0.84),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallStat extends StatelessWidget {
  const _SmallStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.16),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.22)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white.withOpacity(0.84),
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
