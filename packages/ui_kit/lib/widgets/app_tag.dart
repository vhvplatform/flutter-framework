import 'package:flutter/material.dart';

/// A tag widget for displaying labeled items with optional deletion
class AppTag extends StatelessWidget {
  final String label;
  final Color? color;
  final Color? textColor;
  final VoidCallback? onDeleted;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final bool outlined;

  const AppTag({
    super.key,
    required this.label,
    this.color,
    this.textColor,
    this.onDeleted,
    this.onTap,
    this.padding,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = color ?? theme.colorScheme.primary.withOpacity(0.1);
    final fgColor = textColor ?? theme.colorScheme.primary;

    return Material(
      color: outlined ? Colors.transparent : bgColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: outlined
              ? BoxDecoration(
                  border: Border.all(color: fgColor),
                  borderRadius: BorderRadius.circular(16),
                )
              : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: fgColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (onDeleted != null) ...[
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: onDeleted,
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: fgColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A group of tags with wrap layout
class AppTagGroup extends StatelessWidget {
  final List<String> tags;
  final Color? color;
  final ValueChanged<String>? onTagDeleted;
  final ValueChanged<String>? onTagTapped;
  final double spacing;
  final double runSpacing;
  final bool outlined;

  const AppTagGroup({
    super.key,
    required this.tags,
    this.color,
    this.onTagDeleted,
    this.onTagTapped,
    this.spacing = 8,
    this.runSpacing = 8,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: tags
          .map(
            (tag) => AppTag(
              label: tag,
              color: color,
              outlined: outlined,
              onDeleted: onTagDeleted != null ? () => onTagDeleted!(tag) : null,
              onTap: onTagTapped != null ? () => onTagTapped!(tag) : null,
            ),
          )
          .toList(),
    );
  }
}
