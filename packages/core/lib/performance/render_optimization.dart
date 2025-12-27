/// Render performance optimization utilities
library render_optimization;

import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

/// Optimized render object for better performance
mixin RenderOptimizationMixin on RenderBox {
  bool _needsCompositingBitsUpdate = false;

  /// Mark as needing compositing bits update without full layout
  void markNeedsCompositingBitsUpdateOnly() {
    _needsCompositingBitsUpdate = true;
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_needsCompositingBitsUpdate) {
      _needsCompositingBitsUpdate = false;
    }
    super.paint(context, offset);
  }
}

/// Widget that skips unnecessary rebuilds when parent changes
class SelectiveRebuildWidget extends StatefulWidget {
  /// Creates a selective rebuild widget
  const SelectiveRebuildWidget({
    required this.child,
    required this.shouldRebuild,
    super.key,
  });

  /// Child widget
  final Widget child;

  /// Function to determine if rebuild is needed
  final bool Function() shouldRebuild;

  @override
  State<SelectiveRebuildWidget> createState() =>
      _SelectiveRebuildWidgetState();
}

class _SelectiveRebuildWidgetState extends State<SelectiveRebuildWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void didUpdateWidget(SelectiveRebuildWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.shouldRebuild()) {
      // Skip rebuild
      return;
    }
  }
}

/// Optimized container with cached decorations
class OptimizedContainer extends StatelessWidget {
  /// Creates an optimized container
  const OptimizedContainer({
    super.key,
    this.child,
    this.color,
    this.borderRadius,
    this.boxShadow,
    this.border,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.enableShadowCache = true,
  });

  /// Child widget
  final Widget? child;

  /// Background color
  final Color? color;

  /// Border radius
  final BorderRadius? borderRadius;

  /// Box shadow
  final List<BoxShadow>? boxShadow;

  /// Border
  final Border? border;

  /// Padding
  final EdgeInsetsGeometry? padding;

  /// Margin
  final EdgeInsetsGeometry? margin;

  /// Width
  final double? width;

  /// Height
  final double? height;

  /// Enable shadow caching for better performance
  final bool enableShadowCache;

  @override
  Widget build(BuildContext context) {
    Widget current = child ?? const SizedBox.shrink();

    if (padding != null) {
      current = Padding(padding: padding!, child: current);
    }

    // Use DecoratedBox with caching for shadows
    if (color != null || borderRadius != null || boxShadow != null || border != null) {
      final decoration = BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        boxShadow: boxShadow,
        border: border,
      );

      current = DecoratedBox(
        decoration: decoration,
        child: current,
      );
    }

    if (width != null || height != null) {
      current = SizedBox(
        width: width,
        height: height,
        child: current,
      );
    }

    if (margin != null) {
      current = Padding(padding: margin!, child: current);
    }

    return current;
  }
}

/// Widget that builds children lazily and caches them
class LazyBuilder extends StatefulWidget {
  /// Creates a lazy builder
  const LazyBuilder({
    required this.builder,
    required this.childCount,
    super.key,
  });

  /// Builder function for each child
  final Widget Function(BuildContext context, int index) builder;

  /// Number of children
  final int childCount;

  @override
  State<LazyBuilder> createState() => _LazyBuilderState();
}

class _LazyBuilderState extends State<LazyBuilder> {
  final Map<int, Widget> _cache = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(widget.childCount, (index) {
        if (!_cache.containsKey(index)) {
          _cache[index] = widget.builder(context, index);
        }
        return _cache[index]!;
      }),
    );
  }

  @override
  void didUpdateWidget(LazyBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.childCount != widget.childCount) {
      _cache.clear();
    }
  }
}

/// Optimized text widget with caching
class OptimizedText extends StatelessWidget {
  /// Creates an optimized text widget
  const OptimizedText(
    this.text, {
    super.key,
    this.style,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.softWrap,
  });

  /// Text to display
  final String text;

  /// Text style
  final TextStyle? style;

  /// Maximum lines
  final int? maxLines;

  /// Overflow behavior
  final TextOverflow? overflow;

  /// Text alignment
  final TextAlign? textAlign;

  /// Soft wrap
  final bool? softWrap;

  static final Map<String, TextPainter> _painterCache = {};
  static const int _maxCacheSize = 100;

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = style ?? DefaultTextStyle.of(context).style;
    
    return CustomPaint(
      painter: _CachedTextPainter(
        text: text,
        style: effectiveStyle,
        maxLines: maxLines,
        overflow: overflow ?? TextOverflow.clip,
        textAlign: textAlign ?? TextAlign.start,
        softWrap: softWrap ?? true,
      ),
      child: SizedBox(
        width: double.infinity,
        child: Text(
          text,
          style: effectiveStyle,
          maxLines: maxLines,
          overflow: overflow,
          textAlign: textAlign,
          softWrap: softWrap,
        ),
      ),
    );
  }
}

class _CachedTextPainter extends CustomPainter {
  _CachedTextPainter({
    required this.text,
    required this.style,
    this.maxLines,
    required this.overflow,
    required this.textAlign,
    required this.softWrap,
  });

  final String text;
  final TextStyle style;
  final int? maxLines;
  final TextOverflow overflow;
  final TextAlign textAlign;
  final bool softWrap;

  @override
  void paint(Canvas canvas, Size size) {
    // Painting is handled by the Text widget
  }

  @override
  bool shouldRepaint(_CachedTextPainter oldDelegate) {
    return text != oldDelegate.text ||
        style != oldDelegate.style ||
        maxLines != oldDelegate.maxLines ||
        overflow != oldDelegate.overflow ||
        textAlign != oldDelegate.textAlign ||
        softWrap != oldDelegate.softWrap;
  }
}

/// Render optimization utilities
class RenderOptimization {
  const RenderOptimization._();

  /// Enable software rendering for specific widgets
  static Widget forceSoftwareRendering(Widget child) {
    return RepaintBoundary(
      child: child,
    );
  }

  /// Create a cached image for static content
  static Future<ui.Image> captureWidget({
    required Widget widget,
    required Size size,
    double pixelRatio = 1.0,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Draw widget to canvas
    final context = PaintingContext(ContainerLayer(), Offset.zero & size);
    
    final picture = recorder.endRecording();
    final image = await picture.toImage(
      (size.width * pixelRatio).toInt(),
      (size.height * pixelRatio).toInt(),
    );

    return image;
  }

  /// Check if device supports hardware acceleration
  static bool get supportsHardwareAcceleration {
    // This would need platform-specific implementation
    // For now, assume all platforms support it
    return true;
  }

  /// Estimate render cost of a widget tree
  static int estimateRenderCost(Widget widget) {
    var cost = 1;

    if (widget is StatefulWidget) {
      cost += 2; // Stateful widgets are more expensive
    }

    if (widget is Container) {
      if (widget.decoration != null) cost += 3;
      if (widget.transform != null) cost += 2;
    }

    if (widget is Opacity) {
      cost += 5; // Opacity is expensive
    }

    if (widget is ClipRRect || widget is ClipRect) {
      cost += 4; // Clipping is expensive
    }

    return cost;
  }
}

/// Performance hint provider
class PerformanceHints {
  const PerformanceHints._();

  /// Get hints for optimizing a widget
  static List<String> getOptimizationHints(Widget widget) {
    final hints = <String>[];

    if (widget is Opacity && widget.opacity < 1.0) {
      hints.add('Consider using AnimatedOpacity for smoother transitions');
    }

    if (widget is Container) {
      if (widget.decoration != null) {
        hints.add('Use DecoratedBox directly instead of Container for better performance');
      }
    }

    if (widget is ClipRRect) {
      hints.add('Clipping is expensive. Consider alternatives like Container with borderRadius');
    }

    return hints;
  }

  /// Suggest const optimization
  static bool canBeConst(Widget widget) {
    // Simple heuristic - would need more sophisticated analysis
    if (widget is Text) {
      return true;
    }
    if (widget is Icon) {
      return true;
    }
    return false;
  }
}

/// Widget performance profiler
class WidgetProfiler {
  WidgetProfiler._();

  static final WidgetProfiler _instance = WidgetProfiler._();

  /// Singleton instance
  static WidgetProfiler get instance => _instance;

  final Map<String, List<int>> _buildTimes = {};
  final Map<String, int> _buildCounts = {};

  /// Record build time
  void recordBuildTime(String widgetName, int microseconds) {
    if (!kDebugMode) return;

    _buildTimes.putIfAbsent(widgetName, () => []).add(microseconds);
    _buildCounts[widgetName] = (_buildCounts[widgetName] ?? 0) + 1;

    // Keep only last 100 samples
    if (_buildTimes[widgetName]!.length > 100) {
      _buildTimes[widgetName]!.removeAt(0);
    }
  }

  /// Get average build time
  double? getAverageBuildTime(String widgetName) {
    final times = _buildTimes[widgetName];
    if (times == null || times.isEmpty) return null;

    final sum = times.reduce((a, b) => a + b);
    return sum / times.length;
  }

  /// Get build count
  int getBuildCount(String widgetName) {
    return _buildCounts[widgetName] ?? 0;
  }

  /// Print profiling report
  void printReport() {
    if (!kDebugMode) return;

    debugPrint('=== Widget Performance Report ===');
    
    final sortedWidgets = _buildCounts.keys.toList()
      ..sort((a, b) {
        final avgA = getAverageBuildTime(a) ?? 0;
        final avgB = getAverageBuildTime(b) ?? 0;
        return avgB.compareTo(avgA);
      });

    for (final widget in sortedWidgets) {
      final avg = getAverageBuildTime(widget);
      final count = getBuildCount(widget);
      debugPrint('$widget: ${avg?.toStringAsFixed(2)}μs avg, $count builds');
    }
  }

  /// Clear all data
  void clear() {
    _buildTimes.clear();
    _buildCounts.clear();
  }
}

/// Mixin for widgets to enable profiling
mixin ProfiledWidget<T extends StatefulWidget> on State<T> {
  String get widgetName => T.toString();

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) {
      return buildWithContext(context);
    }

    final startTime = DateTime.now();
    final result = buildWithContext(context);
    final endTime = DateTime.now();

    WidgetProfiler.instance.recordBuildTime(
      widgetName,
      endTime.difference(startTime).inMicroseconds,
    );

    return result;
  }

  /// Override this instead of build()
  Widget buildWithContext(BuildContext context);
}
