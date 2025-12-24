import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// A user avatar widget with fallback initials.
///
/// Example:
/// ```dart
/// // With image
/// AppAvatar(
///   imageUrl: 'https://example.com/avatar.jpg',
///   size: 48,
/// )
///
/// // With initials
/// AppAvatar(
///   name: 'John Doe',
///   size: 48,
/// )
/// ```
class AppAvatar extends StatelessWidget {
  /// Image URL
  final String? imageUrl;
  
  /// Name to generate initials from
  final String? name;
  
  /// Avatar size
  final double size;
  
  /// Background color for initials
  final Color? backgroundColor;
  
  /// Text color for initials
  final Color? textColor;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = 40,
    this.backgroundColor,
    this.textColor,
  });

  String _getInitials() {
    if (name == null || name!.isEmpty) return '?';
    
    final parts = name!.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name![0].toUpperCase();
  }

  Color _getBackgroundColor(BuildContext context) {
    if (backgroundColor != null) return backgroundColor!;
    
    // Generate color from name
    if (name != null && name!.isNotEmpty) {
      final hash = name!.hashCode;
      final colors = [
        Colors.red[400]!,
        Colors.pink[400]!,
        Colors.purple[400]!,
        Colors.deepPurple[400]!,
        Colors.indigo[400]!,
        Colors.blue[400]!,
        Colors.cyan[400]!,
        Colors.teal[400]!,
        Colors.green[400]!,
        Colors.orange[400]!,
      ];
      return colors[hash % colors.length];
    }
    
    return Theme.of(context).colorScheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: size / 2,
        backgroundImage: CachedNetworkImageProvider(imageUrl!),
        backgroundColor: _getBackgroundColor(context),
      );
    }

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: _getBackgroundColor(context),
      child: Text(
        _getInitials(),
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: size * 0.4,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
