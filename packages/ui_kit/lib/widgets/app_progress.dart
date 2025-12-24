import 'package:flutter/material.dart';

/// A linear progress indicator with label and percentage display.
///
/// Example:
/// ```dart
/// AppLinearProgress(
///   value: 0.65,
///   label: 'Upload progress',
///   showPercentage: true,
/// )
/// ```
class AppLinearProgress extends StatelessWidget {
  final double? value;
  final String? label;
  final bool showPercentage;
  final Color? color;
  final Color? backgroundColor;
  final double height;

  const AppLinearProgress({
    super.key,
    this.value,
    this.label,
    this.showPercentage = false,
    this.color,
    this.backgroundColor,
    this.height = 8,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null || (showPercentage && value != null))
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (label != null)
                  Expanded(
                    child: Text(
                      label!,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                if (showPercentage && value != null)
                  Text(
                    '${(value! * 100).toStringAsFixed(0)}%',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: SizedBox(
            height: height,
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: backgroundColor,
              valueColor: color != null
                  ? AlwaysStoppedAnimation<Color>(color!)
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}

/// A circular progress indicator with percentage display.
///
/// Example:
/// ```dart
/// AppCircularProgress(
///   value: 0.75,
///   size: 100,
///   showPercentage: true,
/// )
/// ```
class AppCircularProgress extends StatelessWidget {
  final double? value;
  final double size;
  final bool showPercentage;
  final Color? color;
  final Color? backgroundColor;
  final double strokeWidth;

  const AppCircularProgress({
    super.key,
    this.value,
    this.size = 48,
    this.showPercentage = false,
    this.color,
    this.backgroundColor,
    this.strokeWidth = 4,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: value,
            strokeWidth: strokeWidth,
            backgroundColor: backgroundColor,
            valueColor: color != null
                ? AlwaysStoppedAnimation<Color>(color!)
                : null,
          ),
          if (showPercentage && value != null)
            Text(
              '${(value! * 100).toStringAsFixed(0)}%',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}
