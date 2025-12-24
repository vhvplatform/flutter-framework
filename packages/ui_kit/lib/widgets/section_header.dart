import 'package:flutter/material.dart';

/// A section header widget for lists.
///
/// Example:
/// ```dart
/// SectionHeader(
///   title: 'Recent Items',
///   action: TextButton(
///     child: Text('See All'),
///     onPressed: () {},
///   ),
/// )
/// ```
class SectionHeader extends StatelessWidget {
  /// Header title
  final String title;
  
  /// Optional action widget (e.g., button)
  final Widget? action;
  
  /// Padding
  final EdgeInsets padding;

  const SectionHeader({
    super.key,
    required this.title,
    this.action,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}
