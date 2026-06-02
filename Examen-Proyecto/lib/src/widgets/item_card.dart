import 'package:flutter/material.dart';
import '../models.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({
    required this.item,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final CrudItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFEF4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: item.color.withOpacity(0.35), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 20,
            offset: Offset(0, 10),
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
                    color: item.color.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(Icons.movie_rounded, color: item.color),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.director,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.black.withOpacity(0.58),
                        ),
                      ),
                    ],
                  ),
                ),
                StatusChip(label: item.location, color: item.color),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                InfoChip(icon: Icons.calendar_today, text: '${item.year}'),
                InfoChip(icon: Icons.location_on, text: item.location),
                InfoChip(icon: Icons.event, text: formatDate(item.dateWatched)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                TextButton.icon(
                  onPressed: onEdit,
                  icon: Icon(Icons.edit, color: colorScheme.primary),
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

class StatusChip extends StatelessWidget {
  const StatusChip({required this.label, required this.color, super.key});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.35)),
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

class InfoChip extends StatelessWidget {
  const InfoChip({required this.icon, required this.text, super.key});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3D9),
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
