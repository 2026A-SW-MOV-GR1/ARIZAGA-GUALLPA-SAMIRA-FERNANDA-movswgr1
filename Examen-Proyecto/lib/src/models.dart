import 'package:flutter/material.dart';

class CrudFormResult {
  const CrudFormResult({required this.item, required this.isEditing});

  final CrudItem item;
  final bool isEditing;
}

class CrudItem {
  const CrudItem({
    required this.id,
    required this.title,
    required this.year,
    required this.director,
    required this.location,
    required this.dateWatched,
    required this.color,
  });

  final int id;
  final String title;
  final int year;
  final String director;
  final String location; // 'Casa' o 'Cine'
  final DateTime dateWatched;
  final Color color;

  CrudItem copyWith({
    int? id,
    String? title,
    int? year,
    String? director,
    String? location,
    DateTime? dateWatched,
    Color? color,
  }) {
    return CrudItem(
      id: id ?? this.id,
      title: title ?? this.title,
      year: year ?? this.year,
      director: director ?? this.director,
      location: location ?? this.location,
      dateWatched: dateWatched ?? this.dateWatched,
      color: color ?? this.color,
    );
  }
}

String formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}
