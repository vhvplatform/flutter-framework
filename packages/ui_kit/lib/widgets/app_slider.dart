import 'package:flutter/material.dart';

/// A customized slider widget with label and value display.
///
/// Example:
/// ```dart
/// AppSlider(
///   value: _volume,
///   onChanged: (value) => setState(() => _volume = value),
///   label: 'Volume',
///   min: 0,
///   max: 100,
///   showValue: true,
/// )
/// ```
class AppSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final String? label;
  final double min;
  final double max;
  final int? divisions;
  final bool showValue;
  final String Function(double)? valueFormatter;
  final Color? activeColor;

  const AppSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.showValue = false,
    this.valueFormatter,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null || showValue)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (label != null)
                  Text(
                    label!,
                    style: theme.textTheme.bodyMedium,
                  ),
                if (showValue)
                  Text(
                    valueFormatter?.call(value) ?? value.toStringAsFixed(0),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        Slider(
          value: value,
          onChanged: onChanged,
          min: min,
          max: max,
          divisions: divisions,
          activeColor: activeColor,
        ),
      ],
    );
  }
}
