import 'package:flutter/material.dart';

/// A timeline widget for displaying chronological events
class AppTimeline extends StatelessWidget {
  final List<TimelineItem> items;
  final Color? lineColor;
  final Color? dotColor;
  final double lineWidth;
  final double dotSize;
  final EdgeInsets itemPadding;

  const AppTimeline({
    super.key,
    required this.items,
    this.lineColor,
    this.dotColor,
    this.lineWidth = 2,
    this.dotSize = 12,
    this.itemPadding = const EdgeInsets.symmetric(vertical: 16),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lineClr = lineColor ?? theme.colorScheme.primary.withOpacity(0.3);
    final dotClr = dotColor ?? theme.colorScheme.primary;

    return Column(
      children: items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        final isLast = index == items.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline indicator
            Column(
              children: [
                Container(
                  width: dotSize,
                  height: dotSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: item.dotColor ?? dotClr,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                ),
                if (!isLast)
                  Container(
                    width: lineWidth,
                    height: 60,
                    color: lineClr,
                  ),
              ],
            ),
            const SizedBox(width: 16),

            // Content
            Expanded(
              child: Padding(
                padding: itemPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (item.title != null)
                      Text(
                        item.title!,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    if (item.subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        item.subtitle!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                    if (item.child != null) ...[
                      const SizedBox(height: 8),
                      item.child!,
                    ],
                    if (item.timestamp != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        item.timestamp!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

/// Timeline item configuration
class TimelineItem {
  final String? title;
  final String? subtitle;
  final Widget? child;
  final String? timestamp;
  final Color? dotColor;

  const TimelineItem({
    this.title,
    this.subtitle,
    this.child,
    this.timestamp,
    this.dotColor,
  });
}
