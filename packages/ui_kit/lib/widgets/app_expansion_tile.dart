import 'package:flutter/material.dart';

/// A customized expansion tile with modern styling.
///
/// Example:
/// ```dart
/// AppExpansionTile(
///   title: 'Section 1',
///   subtitle: 'Tap to expand',
///   children: [
///     ListTile(title: Text('Item 1')),
///     ListTile(title: Text('Item 2')),
///   ],
/// )
/// ```
class AppExpansionTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget> children;
  final bool initiallyExpanded;
  final ValueChanged<bool>? onExpansionChanged;
  final Color? backgroundColor;
  final Color? collapsedBackgroundColor;

  const AppExpansionTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    required this.children,
    this.initiallyExpanded = false,
    this.onExpansionChanged,
    this.backgroundColor,
    this.collapsedBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      leading: leading,
      initiallyExpanded: initiallyExpanded,
      onExpansionChanged: onExpansionChanged,
      backgroundColor: backgroundColor,
      collapsedBackgroundColor: collapsedBackgroundColor,
      childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: children,
    );
  }
}
