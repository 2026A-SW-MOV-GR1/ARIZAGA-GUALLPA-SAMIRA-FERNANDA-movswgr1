import 'package:flutter/material.dart';

import '../models/movie.dart';

class MovieTile extends StatelessWidget {
  const MovieTile({
    required this.movie,
    required this.storageLabel,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final Movie movie;
  final String storageLabel;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final accent = _accentFor(movie.id ?? movie.year);
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accent.withOpacity(0.18)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 22,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(Icons.movie_rounded, color: accent),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        movie.director,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: onSurface.withOpacity(0.64),
                        ),
                      ),
                    ],
                  ),
                ),
                _StorageBadge(label: storageLabel, color: accent),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _InfoChip(icon: Icons.calendar_month, text: '${movie.year}'),
                _InfoChip(icon: Icons.place_outlined, text: movie.location),
                _InfoChip(
                  icon: Icons.event_available,
                  text: formatDate(movie.watchedOn),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                TextButton.icon(
                  onPressed: onEdit,
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  label: const Text('Editar'),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                  label: const Text('Eliminar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Color _accentFor(int seed) {
  const palette = [
    Color(0xFF2F80ED),
    Color(0xFF0F9D58),
    Color(0xFFF2994A),
    Color(0xFF9B51E0),
  ];
  return palette[seed.abs() % palette.length];
}

class _StorageBadge extends StatelessWidget {
  const _StorageBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F6FB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.black54),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}
