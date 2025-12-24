import 'package:flutter/material.dart';

/// A customized checkbox widget with label support.
///
/// Example:
/// ```dart
/// AppCheckbox(
///   value: _agreed,
///   onChanged: (value) => setState(() => _agreed = value ?? false),
///   label: 'I agree to the terms and conditions',
/// )
/// ```
class AppCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final String? label;
  final Color? activeColor;
  final bool tristate;

  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.activeColor,
    this.tristate = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = onChanged != null;

    if (label == null) {
      return Checkbox(
        value: value,
        onChanged: onChanged,
        activeColor: activeColor,
        tristate: tristate,
      );
    }

    return InkWell(
      onTap: isEnabled ? () => onChanged?.call(!value) : null,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: activeColor,
              tristate: tristate,
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
