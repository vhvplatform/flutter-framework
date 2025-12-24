import 'package:flutter/material.dart';

/// Button variants
enum ButtonVariant {
  /// Primary button style
  primary,
  
  /// Secondary button style
  secondary,
  
  /// Outline button style
  outline,
  
  /// Text button style
  text,
}

/// Customizable button widget
class AppButton extends StatelessWidget {
  /// Creates an app button
  const AppButton({
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.width,
    super.key,
  });

  /// Button text
  final String text;
  
  /// Button press callback
  final VoidCallback? onPressed;
  
  /// Button variant
  final ButtonVariant variant;
  
  /// Whether button is in loading state
  final bool isLoading;
  
  /// Whether button is disabled
  final bool isDisabled;
  
  /// Optional icon
  final IconData? icon;
  
  /// Optional button width
  final double? width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = !isDisabled && !isLoading && onPressed != null;

    Widget child = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: 8),
              ],
              Text(text),
            ],
          );

    Widget button;

    switch (variant) {
      case ButtonVariant.primary:
        button = ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          child: child,
        );
        break;
      case ButtonVariant.secondary:
        button = ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.secondary,
            foregroundColor: theme.colorScheme.onSecondary,
          ),
          child: child,
        );
        break;
      case ButtonVariant.outline:
        button = OutlinedButton(
          onPressed: isEnabled ? onPressed : null,
          child: child,
        );
        break;
      case ButtonVariant.text:
        button = TextButton(
          onPressed: isEnabled ? onPressed : null,
          child: child,
        );
        break;
    }

    if (width != null) {
      return SizedBox(
        width: width,
        child: button,
      );
    }

    return button;
  }
}
