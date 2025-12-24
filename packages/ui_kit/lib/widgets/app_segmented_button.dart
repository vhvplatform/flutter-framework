import 'package:flutter/material.dart';

/// A segmented button group for selecting between options
class AppSegmentedButton<T> extends StatelessWidget {
  final T selectedValue;
  final List<SegmentOption<T>> options;
  final ValueChanged<T> onChanged;
  final bool multiSelectionEnabled;
  final Set<T> selectedValues;
  final ValueChanged<Set<T>>? onMultiChanged;

  const AppSegmentedButton({
    super.key,
    required this.selectedValue,
    required this.options,
    required this.onChanged,
    this.multiSelectionEnabled = false,
    this.selectedValues = const {},
    this.onMultiChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (multiSelectionEnabled) {
      return SegmentedButton<T>(
        segments: options
            .map(
              (option) => ButtonSegment<T>(
                value: option.value,
                label: Text(option.label),
                icon: option.icon != null ? Icon(option.icon) : null,
                enabled: option.enabled,
              ),
            )
            .toList(),
        selected: selectedValues,
        onSelectionChanged: onMultiChanged ?? (values) {},
        multiSelectionEnabled: true,
      );
    }

    return SegmentedButton<T>(
      segments: options
          .map(
            (option) => ButtonSegment<T>(
              value: option.value,
              label: Text(option.label),
              icon: option.icon != null ? Icon(option.icon) : null,
              enabled: option.enabled,
            ),
          )
          .toList(),
      selected: {selectedValue},
      onSelectionChanged: (values) {
        if (values.isNotEmpty) {
          onChanged(values.first);
        }
      },
    );
  }
}

/// Segment option configuration
class SegmentOption<T> {
  final T value;
  final String label;
  final IconData? icon;
  final bool enabled;

  const SegmentOption({
    required this.value,
    required this.label,
    this.icon,
    this.enabled = true,
  });
}
