import 'package:flutter/material.dart';

/// Stats widget for displaying metrics
class StatsWidget extends StatelessWidget {
  /// Creates a stats widget
  const StatsWidget({
    required this.title,
    required this.value,
    this.icon,
    this.trend,
    super.key,
  });

  /// Stats title
  final String title;
  
  /// Stats value
  final String value;
  
  /// Optional icon
  final IconData? icon;
  
  /// Optional trend indicator
  final String? trend;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                if (icon != null)
                  Icon(
                    icon,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (trend != null) ...[
              const SizedBox(height: 8),
              Text(
                trend!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
