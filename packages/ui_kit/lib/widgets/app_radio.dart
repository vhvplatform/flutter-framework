import 'package:flutter/material.dart';

/// A customized radio button widget with label support.
///
/// Example:
/// ```dart
/// AppRadio<String>(
///   value: 'option1',
///   groupValue: _selectedOption,
///   onChanged: (value) => setState(() => _selectedOption = value),
///   label: 'Option 1',
/// )
/// ```
class AppRadio<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final Color? activeColor;

  const AppRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.label,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = onChanged != null;

    if (label == null) {
      return Radio<T>(
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        activeColor: activeColor,
      );
    }

    return InkWell(
      onTap: isEnabled ? () => onChanged?.call(value) : null,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Radio<T>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: activeColor,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isEnabled ? null : theme.disabledColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A group of radio buttons organized vertically.
///
/// Example:
/// ```dart
/// AppRadioGroup<String>(
///   value: _selectedOption,
///   onChanged: (value) => setState(() => _selectedOption = value),
///   options: [
///     RadioOption(value: 'option1', label: 'Option 1'),
///     RadioOption(value: 'option2', label: 'Option 2'),
///   ],
/// )
/// ```
class AppRadioGroup<T> extends StatelessWidget {
  final T? value;
  final ValueChanged<T?>? onChanged;
  final List<RadioOption<T>> options;
  final String? title;

  const AppRadioGroup({
    super.key,
    required this.value,
    required this.onChanged,
    required this.options,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
        ],
        ...options.map((option) => AppRadio<T>(
              value: option.value,
              groupValue: value,
              onChanged: onChanged,
              label: option.label,
            )),
      ],
    );
  }
}

/// Option data class for radio group.
class RadioOption<T> {
  final T value;
  final String label;

  const RadioOption({
    required this.value,
    required this.label,
  });
}
