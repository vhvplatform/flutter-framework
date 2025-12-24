import 'package:flutter/material.dart';

/// A dropdown selector widget with search support.
///
/// Example:
/// ```dart
/// AppDropdown<String>(
///   value: selectedValue,
///   items: ['Option 1', 'Option 2', 'Option 3'],
///   onChanged: (value) => setState(() => selectedValue = value),
///   label: 'Select Option',
/// )
/// ```
class AppDropdown<T> extends StatelessWidget {
  /// Current selected value
  final T? value;
  
  /// List of items to display
  final List<T> items;
  
  /// Callback when value changes
  final ValueChanged<T?>? onChanged;
  
  /// Label displayed above dropdown
  final String? label;
  
  /// Hint text when no value selected
  final String? hint;
  
  /// Function to get display text for item
  final String Function(T)? itemBuilder;
  
  /// Whether dropdown is enabled
  final bool enabled;

  const AppDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.label,
    this.hint,
    this.itemBuilder,
    this.enabled = true,
  });

  String _getItemText(T item) {
    if (itemBuilder != null) {
      return itemBuilder!(item);
    }
    return item.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
        ],
        DropdownButtonFormField<T>(
          value: value,
          items: items
              .map((item) => DropdownMenuItem<T>(
                    value: item,
                    child: Text(_getItemText(item)),
                  ))
              .toList(),
          onChanged: enabled ? onChanged : null,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}
