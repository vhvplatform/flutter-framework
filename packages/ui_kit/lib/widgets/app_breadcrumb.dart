import 'package:flutter/material.dart';

/// A breadcrumb navigation widget
class AppBreadcrumb extends StatelessWidget {
  final List<BreadcrumbItem> items;
  final Color? activeColor;
  final Color? inactiveColor;
  final double fontSize;
  final IconData separatorIcon;

  const AppBreadcrumb({
    super.key,
    required this.items,
    this.activeColor,
    this.inactiveColor,
    this.fontSize = 14,
    this.separatorIcon = Icons.chevron_right,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeClr = activeColor ?? theme.colorScheme.primary;
    final inactiveClr = inactiveColor ?? theme.textTheme.bodyMedium?.color?.withOpacity(0.6);

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: items.asMap().entries.expand((entry) {
        final index = entry.key;
        final item = entry.value;
        final isLast = index == items.length - 1;

        return [
          if (index > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Icon(
                separatorIcon,
                size: fontSize + 2,
                color: inactiveClr,
              ),
            ),
          InkWell(
            onTap: !isLast && item.onTap != null ? item.onTap : null,
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                item.label,
                style: TextStyle(
                  fontSize: fontSize,
                  color: isLast ? activeClr : inactiveClr,
                  fontWeight: isLast ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ),
        ];
      }).toList(),
    );
  }
}

/// Breadcrumb item configuration
class BreadcrumbItem {
  final String label;
  final VoidCallback? onTap;

  const BreadcrumbItem({
    required this.label,
    this.onTap,
  });
}
