import 'package:flutter/material.dart';

/// A banner widget for displaying important messages
class AppBanner extends StatelessWidget {
  final String message;
  final BannerType type;
  final IconData? icon;
  final List<Widget>? actions;
  final VoidCallback? onDismiss;
  final EdgeInsets? padding;

  const AppBanner({
    super.key,
    required this.message,
    this.type = BannerType.info,
    this.icon,
    this.actions,
    this.onDismiss,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = _getColors(context);

    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors['background'],
        border: Border.all(color: colors['border']!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            icon ?? _getDefaultIcon(),
            color: colors['foreground'],
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors['foreground'],
              ),
            ),
          ),
          if (actions != null) ...[
            const SizedBox(width: 12),
            ...actions!,
          ],
          if (onDismiss != null) ...[
            const SizedBox(width: 12),
            IconButton(
              onPressed: onDismiss,
              icon: Icon(Icons.close, color: colors['foreground']),
              iconSize: 20,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getDefaultIcon() {
    switch (type) {
      case BannerType.success:
        return Icons.check_circle_outline;
      case BannerType.warning:
        return Icons.warning_amber_outlined;
      case BannerType.error:
        return Icons.error_outline;
      case BannerType.info:
      default:
        return Icons.info_outline;
    }
  }

  Map<String, Color> _getColors(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    switch (type) {
      case BannerType.success:
        return {
          'background': isDark ? Colors.green.shade900.withOpacity(0.3) : Colors.green.shade50,
          'border': Colors.green.shade300,
          'foreground': isDark ? Colors.green.shade200 : Colors.green.shade900,
        };
      case BannerType.warning:
        return {
          'background': isDark ? Colors.orange.shade900.withOpacity(0.3) : Colors.orange.shade50,
          'border': Colors.orange.shade300,
          'foreground': isDark ? Colors.orange.shade200 : Colors.orange.shade900,
        };
      case BannerType.error:
        return {
          'background': isDark ? Colors.red.shade900.withOpacity(0.3) : Colors.red.shade50,
          'border': Colors.red.shade300,
          'foreground': isDark ? Colors.red.shade200 : Colors.red.shade900,
        };
      case BannerType.info:
      default:
        return {
          'background': isDark ? Colors.blue.shade900.withOpacity(0.3) : Colors.blue.shade50,
          'border': Colors.blue.shade300,
          'foreground': isDark ? Colors.blue.shade200 : Colors.blue.shade900,
        };
    }
  }
}

/// Banner type enumeration
enum BannerType {
  info,
  success,
  warning,
  error,
}
