import 'package:flutter/material.dart';

/// A badge widget for notifications and indicators.
///
/// Example:
/// ```dart
/// AppBadge(
///   count: 5,
///   child: Icon(Icons.notifications),
/// )
/// ```
class AppBadge extends StatelessWidget {
  /// Count to display in badge
  final int count;
  
  /// Child widget to add badge to
  final Widget child;
  
  /// Maximum count to display (shows 99+ if exceeded)
  final int maxCount;
  
  /// Badge color
  final Color? color;
  
  /// Show badge even if count is 0
  final bool showZero;

  const AppBadge({
    super.key,
    required this.count,
    required this.child,
    this.maxCount = 99,
    this.color,
    this.showZero = false,
  });

  @override
  Widget build(BuildContext context) {
    if (count == 0 && !showZero) {
      return child;
    }

    final displayCount = count > maxCount ? '$maxCount+' : count.toString();

    return Badge(
      label: Text(displayCount),
      backgroundColor: color ?? Theme.of(context).colorScheme.error,
      child: child,
    );
  }
}
