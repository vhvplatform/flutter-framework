import 'package:flutter/material.dart';

/// Enhanced list tile with better styling.
///
/// Example:
/// ```dart
/// AppListTile(
///   leading: AppAvatar(name: user.name),
///   title: user.name,
///   subtitle: user.email,
///   trailing: Icon(Icons.arrow_forward),
///   onTap: () => openUser(user),
/// )
/// ```
class AppListTile extends StatelessWidget {
  /// Leading widget
  final Widget? leading;
  
  /// Title text
  final String title;
  
  /// Subtitle text
  final String? subtitle;
  
  /// Trailing widget
  final Widget? trailing;
  
  /// Tap callback
  final VoidCallback? onTap;
  
  /// Long press callback
  final VoidCallback? onLongPress;
  
  /// Whether tile is selected
  final bool selected;
  
  /// Whether tile is enabled
  final bool enabled;

  const AppListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.selected = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall,
            )
          : null,
      trailing: trailing,
      onTap: enabled ? onTap : null,
      onLongPress: enabled ? onLongPress : null,
      selected: selected,
      enabled: enabled,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
