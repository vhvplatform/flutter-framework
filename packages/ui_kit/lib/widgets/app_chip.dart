import 'package:flutter/material.dart';

/// A chip widget for tags and filters.
///
/// Example:
/// ```dart
/// AppChip(
///   label: 'Flutter',
///   onDeleted: () => removeTag(),
/// )
/// ```
class AppChip extends StatelessWidget {
  /// Label text
  final String label;
  
  /// Optional avatar/icon
  final Widget? avatar;
  
  /// Callback when chip is deleted
  final VoidCallback? onDeleted;
  
  /// Callback when chip is tapped
  final VoidCallback? onTap;
  
  /// Background color
  final Color? backgroundColor;
  
  /// Selected state
  final bool selected;

  const AppChip({
    super.key,
    required this.label,
    this.avatar,
    this.onDeleted,
    this.onTap,
    this.backgroundColor,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    if (onTap != null) {
      return ActionChip(
        label: Text(label),
        avatar: avatar,
        onPressed: onTap,
        backgroundColor: backgroundColor,
      );
    }

    return Chip(
      label: Text(label),
      avatar: avatar,
      onDeleted: onDeleted,
      deleteIcon: onDeleted != null ? const Icon(Icons.close, size: 18) : null,
      backgroundColor: selected 
          ? Theme.of(context).colorScheme.primaryContainer 
          : backgroundColor,
    );
  }
}
