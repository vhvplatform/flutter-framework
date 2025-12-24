import 'package:flutter/material.dart';

/// A customized tab bar with modern styling.
///
/// Example:
/// ```dart
/// AppTabs(
///   tabs: ['Home', 'Profile', 'Settings'],
///   currentIndex: _currentIndex,
///   onTap: (index) => setState(() => _currentIndex = index),
/// )
/// ```
class AppTabs extends StatelessWidget {
  final List<String> tabs;
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? indicatorColor;
  final EdgeInsets padding;

  const AppTabs({
    super.key,
    required this.tabs,
    required this.currentIndex,
    this.onTap,
    this.activeColor,
    this.inactiveColor,
    this.indicatorColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveActiveColor = activeColor ?? theme.colorScheme.primary;
    final effectiveInactiveColor =
        inactiveColor ?? theme.textTheme.bodyMedium?.color?.withOpacity(0.6);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isActive = index == currentIndex;
          return Expanded(
            child: InkWell(
              onTap: onTap != null ? () => onTap!(index) : null,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isActive
                          ? (indicatorColor ?? effectiveActiveColor)
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  tabs[index],
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isActive ? effectiveActiveColor : effectiveInactiveColor,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
