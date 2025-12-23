import 'package:flutter/material.dart';

/// Centered loading spinner
class LoadingIndicator extends StatelessWidget {
  /// Creates a loading indicator
  const LoadingIndicator({
    this.size = 40,
    this.color,
    super.key,
  });

  /// Size of the loading indicator
  final double size;
  
  /// Color of the loading indicator
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          valueColor: color != null
              ? AlwaysStoppedAnimation<Color>(color!)
              : null,
        ),
      ),
    );
  }
}
