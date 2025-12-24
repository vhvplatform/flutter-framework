import 'package:flutter/material.dart';

/// Custom text input field
class AppTextField extends StatefulWidget {
  /// Creates an app text field
  const AppTextField({
    this.controller,
    this.label,
    this.hint,
    this.initialValue,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.prefixIcon,
    this.suffixIcon,
    this.errorText,
    super.key,
  });

  /// Text editing controller
  final TextEditingController? controller;
  
  /// Field label
  final String? label;
  
  /// Field hint text
  final String? hint;
  
  /// Initial value
  final String? initialValue;
  
  /// Validation function
  final String? Function(String?)? validator;
  
  /// On changed callback
  final void Function(String)? onChanged;
  
  /// On submitted callback
  final void Function(String)? onSubmitted;
  
  /// Keyboard type
  final TextInputType? keyboardType;
  
  /// Text input action
  final TextInputAction? textInputAction;
  
  /// Whether to obscure text
  final bool obscureText;
  
  /// Whether field is enabled
  final bool enabled;
  
  /// Maximum number of lines
  final int? maxLines;
  
  /// Minimum number of lines
  final int? minLines;
  
  /// Prefix icon
  final IconData? prefixIcon;
  
  /// Suffix icon
  final Widget? suffixIcon;
  
  /// Error text
  final String? errorText;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      initialValue: widget.initialValue,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        prefixIcon: widget.prefixIcon != null 
            ? Icon(widget.prefixIcon) 
            : null,
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : widget.suffixIcon,
        errorText: widget.errorText,
      ),
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: _obscureText,
      enabled: widget.enabled,
      maxLines: _obscureText ? 1 : widget.maxLines,
      minLines: widget.minLines,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
    );
  }
}
