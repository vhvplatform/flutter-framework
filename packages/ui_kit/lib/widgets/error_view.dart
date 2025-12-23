import 'package:flutter/material.dart';

/// Error display with retry button
class ErrorView extends StatelessWidget {
  /// Creates an error view
  const ErrorView({
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline,
    this.iconSize = 64,
    super.key,
  });

  /// Error message
  final String message;
  
  /// Retry callback
  final VoidCallback? onRetry;
  
  /// Error icon
  final IconData icon;
  
  /// Icon size
  final double iconSize;

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
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
