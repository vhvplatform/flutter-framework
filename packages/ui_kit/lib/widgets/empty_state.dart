import 'package:flutter/material.dart';

/// Empty state widget with icon and message
class EmptyState extends StatelessWidget {
  /// Creates an empty state widget
  const EmptyState({
    required this.message,
    this.icon = Icons.inbox,
    this.iconSize = 64,
    this.action,
    super.key,
  });

  /// Empty state message
  final String message;
  
  /// Empty state icon
  final IconData icon;
  
  /// Icon size
  final double iconSize;
  
  /// Optional action widget
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: theme.colorScheme.onBackground.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onBackground.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[
              const SizedBox(height: 24),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
