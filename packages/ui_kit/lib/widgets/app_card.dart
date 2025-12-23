import 'package:flutter/material.dart';

/// Container with elevation and border
class AppCard extends StatelessWidget {
  /// Creates an app card
  const AppCard({
    required this.child,
    this.padding,
    this.margin,
    this.elevation,
    this.color,
    this.onTap,
    super.key,
  });

  /// Card child widget
  final Widget child;
  
  /// Card padding
  final EdgeInsetsGeometry? padding;
  
  /// Card margin
  final EdgeInsetsGeometry? margin;
  
  /// Card elevation
  final double? elevation;
  
  /// Card background color
  final Color? color;
  
  /// On tap callback
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Card(
      elevation: elevation,
      color: color,
      margin: margin,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: card,
      );
    }

    return card;
  }
}
