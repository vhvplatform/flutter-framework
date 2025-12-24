import 'package:flutter/material.dart';

/// A divider widget for separating content.
///
/// Example:
/// ```dart
/// AppDivider()
/// AppDivider.vertical(height: 50)
/// ```
class AppDivider extends StatelessWidget {
  /// Divider height (for horizontal divider)
  final double? height;
  
  /// Divider thickness
  final double thickness;
  
  /// Indent from start
  final double indent;
  
  /// Indent from end
  final double endIndent;
  
  /// Divider color
  final Color? color;
  
  /// Whether divider is vertical
  final bool isVertical;

  const AppDivider({
    super.key,
    this.height,
    this.thickness = 1,
    this.indent = 0,
    this.endIndent = 0,
    this.color,
  }) : isVertical = false;

  const AppDivider.vertical({
    super.key,
    this.height,
    this.thickness = 1,
    this.indent = 0,
    this.endIndent = 0,
    this.color,
  }) : isVertical = true;

  @override
  Widget build(BuildContext context) {
    if (isVertical) {
      return VerticalDivider(
        width: height,
        thickness: thickness,
        indent: indent,
        endIndent: endIndent,
        color: color,
      );
    }

    return Divider(
      height: height,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: color,
    );
  }
}
