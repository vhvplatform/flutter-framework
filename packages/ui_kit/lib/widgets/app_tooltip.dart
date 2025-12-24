import 'package:flutter/material.dart';

/// A customized tooltip widget with better styling.
///
/// Example:
/// ```dart
/// AppTooltip(
///   message: 'This is a helpful tooltip',
///   child: Icon(Icons.info_outline),
/// )
/// ```
class AppTooltip extends StatelessWidget {
  final String message;
  final Widget child;
  final Duration? waitDuration;
  final Duration? showDuration;
  final EdgeInsetsGeometry? padding;
  final Decoration? decoration;
  final TextStyle? textStyle;

  const AppTooltip({
    super.key,
    required this.message,
    required this.child,
    this.waitDuration,
    this.showDuration,
    this.padding,
    this.decoration,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      waitDuration: waitDuration ?? const Duration(milliseconds: 500),
      showDuration: showDuration ?? const Duration(seconds: 2),
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: decoration,
      textStyle: textStyle,
      child: child,
    );
  }
}
