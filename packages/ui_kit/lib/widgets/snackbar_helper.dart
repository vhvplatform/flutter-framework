import 'package:flutter/material.dart';

/// Helper class for showing snackbars.
///
/// Example:
/// ```dart
/// SnackbarHelper.showSuccess(context, 'Operation successful!');
/// SnackbarHelper.showError(context, 'Failed to save');
/// ```
class SnackbarHelper {
  /// Show success snackbar
  static void showSuccess(BuildContext context, String message, {Duration? duration}) {
    _show(
      context,
      message,
      backgroundColor: Colors.green[600],
      icon: Icons.check_circle,
      duration: duration,
    );
  }

  /// Show error snackbar
  static void showError(BuildContext context, String message, {Duration? duration}) {
    _show(
      context,
      message,
      backgroundColor: Colors.red[600],
      icon: Icons.error,
      duration: duration,
    );
  }

  /// Show warning snackbar
  static void showWarning(BuildContext context, String message, {Duration? duration}) {
    _show(
      context,
      message,
      backgroundColor: Colors.orange[600],
      icon: Icons.warning,
      duration: duration,
    );
  }

  /// Show info snackbar
  static void showInfo(BuildContext context, String message, {Duration? duration}) {
    _show(
      context,
      message,
      backgroundColor: Colors.blue[600],
      icon: Icons.info,
      duration: duration,
    );
  }

  /// Show custom snackbar
  static void show(
    BuildContext context,
    String message, {
    Duration? duration,
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 3),
        action: action,
      ),
    );
  }

  static void _show(
    BuildContext context,
    String message, {
    required Color? backgroundColor,
    required IconData icon,
    Duration? duration,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: duration ?? const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
