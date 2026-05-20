import 'package:flutter/material.dart';

class HeaderCard extends StatelessWidget {
  const HeaderCard({required this.totalItems, super.key});

  final int totalItems;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 390;
        final imageWidth = compact ? 98.0 : 112.0;

        return SizedBox(
          height: 164,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 12 : 16,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colorScheme.primary, const Color(0xFF8ED8F8)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Bitácora de Películas',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            (compact
                                    ? Theme.of(context).textTheme.headlineSmall
                                    : Theme.of(
                                        context,
                                      ).textTheme.headlineMedium)
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Tus películas vistas, ordenadas en un solo lugar',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _StatPill(label: 'Películas', value: '$totalItems'),
                    ],
                  ),
                ),
                SizedBox(width: compact ? 8 : 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: imageWidth,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white.withOpacity(0.5),
                        width: 1.2,
                      ),
                    ),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?auto=format&fit=crop&w=400&q=80',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.white.withOpacity(0.2),
                          child: const Icon(
                            Icons.photo,
                            color: Colors.white,
                            size: 32,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.24)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
