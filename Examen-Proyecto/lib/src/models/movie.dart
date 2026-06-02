class Movie {
  const Movie({
    required this.title,
    required this.year,
    required this.director,
    required this.location,
    required this.watchedOn,
    this.id,
  });

  final int? id;
  final String title;
  final int year;
  final String director;
  final String location;
  final DateTime watchedOn;

  Movie copyWith({
    int? id,
    String? title,
    int? year,
    String? director,
    String? location,
    DateTime? watchedOn,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      year: year ?? this.year,
      director: director ?? this.director,
      location: location ?? this.location,
      watchedOn: watchedOn ?? this.watchedOn,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'year': year,
      'director': director,
      'location': location,
      'watchedOn': watchedOn.toIso8601String(),
    };
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'] as int?,
      title: map['title'] as String? ?? '',
      year: (map['year'] as num?)?.toInt() ?? 0,
      director: map['director'] as String? ?? '',
      location: map['location'] as String? ?? '',
      watchedOn:
          DateTime.tryParse(map['watchedOn'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}

String formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}
