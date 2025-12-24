import 'package:flutter/material.dart';

/// A search text field widget with clear button and suggestions support.
///
/// Example:
/// ```dart
/// AppSearchField(
///   hint: 'Search users...',
///   onChanged: (value) => performSearch(value),
///   onClear: () => clearSearch(),
/// )
/// ```
class AppSearchField extends StatefulWidget {
  /// Hint text displayed when field is empty
  final String? hint;
  
  /// Callback when text changes
  final ValueChanged<String>? onChanged;
  
  /// Callback when search is submitted
  final ValueChanged<String>? onSubmitted;
  
  /// Callback when clear button is pressed
  final VoidCallback? onClear;
  
  /// Initial value
  final String? initialValue;
  
  /// Controller for the text field
  final TextEditingController? controller;
  
  /// Auto focus on mount
  final bool autofocus;

  const AppSearchField({
    super.key,
    this.hint,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.initialValue,
    this.controller,
    this.autofocus = false,
  });

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  late TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _hasText = _controller.text.isNotEmpty;
    });
  }

  void _onClear() {
    _controller.clear();
    widget.onClear?.call();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      autofocus: widget.autofocus,
      decoration: InputDecoration(
        hintText: widget.hint ?? 'Search...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _hasText
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: _onClear,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
    );
  }
}
