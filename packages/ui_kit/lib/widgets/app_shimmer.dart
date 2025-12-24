import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// A shimmer loading effect widget.
///
/// Example:
/// ```dart
/// AppShimmer(
///   child: Container(
///     width: double.infinity,
///     height: 100,
///     color: Colors.white,
///   ),
/// )
/// ```
class AppShimmer extends StatelessWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;

  const AppShimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: baseColor ??
          (isDark ? Colors.grey[800]! : Colors.grey[300]!),
      highlightColor: highlightColor ??
          (isDark ? Colors.grey[700]! : Colors.grey[100]!),
      child: child,
    );
  }
}

/// Pre-built shimmer skeleton for list items.
class ShimmerListItem extends StatelessWidget {
  final bool hasLeading;
  final bool hasTrailing;
  final int lines;

  const ShimmerListItem({
    super.key,
    this.hasLeading = true,
    this.hasTrailing = false,
    this.lines = 2,
  });

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            if (hasLeading) ...[
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  lines,
                  (index) => Padding(
                    padding: EdgeInsets.only(bottom: index < lines - 1 ? 8 : 0),
                    child: Container(
                      width: index == 0 ? double.infinity : 150,
                      height: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            if (hasTrailing) ...[
              const SizedBox(width: 16),
              Container(
                width: 24,
                height: 24,
                color: Colors.white,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Pre-built shimmer skeleton for cards.
class ShimmerCard extends StatelessWidget {
  final double height;

  const ShimmerCard({
    super.key,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Container(
        height: height,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
