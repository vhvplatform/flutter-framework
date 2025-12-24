import 'package:flutter/material.dart';

/// A customizable popup menu widget
class AppMenu extends StatelessWidget {
  final Widget child;
  final List<AppMenuItem> items;
  final double? elevation;
  final EdgeInsets? padding;

  const AppMenu({
    super.key,
    required this.child,
    required this.items,
    this.elevation,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      itemBuilder: (context) => items
          .asMap()
          .entries
          .map(
            (entry) => PopupMenuItem<int>(
              value: entry.key,
              enabled: entry.value.enabled,
              child: Row(
                children: [
                  if (entry.value.icon != null) ...[
                    Icon(
                      entry.value.icon,
                      size: 20,
                      color: entry.value.isDestructive
                          ? Colors.red
                          : entry.value.enabled
                              ? null
                              : Colors.grey,
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Text(
                      entry.value.label,
                      style: TextStyle(
                        color: entry.value.isDestructive
                            ? Colors.red
                            : entry.value.enabled
                                ? null
                                : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
      onSelected: (index) {
        items[index].onTap?.call();
      },
      elevation: elevation ?? 8,
      padding: padding,
      child: child,
    );
  }
}

/// Menu item configuration
class AppMenuItem {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool enabled;
  final bool isDestructive;

  const AppMenuItem({
    required this.label,
    this.icon,
    this.onTap,
    this.enabled = true,
    this.isDestructive = false,
  });
}
