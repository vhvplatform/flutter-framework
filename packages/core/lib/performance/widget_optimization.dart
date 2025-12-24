/// Advanced widget optimization utilities
library widget_optimization;

import 'package:flutter/widgets.dart';

/// Mixin for widgets that should keep their state alive
mixin KeepAliveMixin<T extends StatefulWidget> on State<T>, AutomaticKeepAliveClientMixin<T> {
  @override
  bool get wantKeepAlive => true;
}

/// Widget that rebuilds only when specific value changes
class ValueListenableSelector<T, S> extends StatelessWidget {
  /// Creates a value listenable selector
  const ValueListenableSelector({
    required this.valueListenable,
    required this.selector,
    required this.builder,
    super.key,
  });

  /// The value listenable to watch
  final ValueListenable<T> valueListenable;
  
  /// Function to select which part of T to watch
  final S Function(T value) selector;
  
  /// Builder that receives the selected value
  final Widget Function(BuildContext context, S value, Widget? child) builder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T>(
      valueListenable: valueListenable,
      builder: (context, value, child) {
        return _SelectorBuilder<S>(
          selector: selector,
          value: value,
          builder: builder,
          child: child,
        );
      },
    );
  }
}

class _SelectorBuilder<S> extends StatefulWidget {
  const _SelectorBuilder({
    required this.selector,
    required this.value,
    required this.builder,
    this.child,
  });

  final S Function(dynamic value) selector;
  final dynamic value;
  final Widget Function(BuildContext context, S value, Widget? child) builder;
  final Widget? child;

  @override
  State<_SelectorBuilder<S>> createState() => _SelectorBuilderState<S>();
}

class _SelectorBuilderState<S> extends State<_SelectorBuilder<S>> {
  late S _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selector(widget.value);
  }

  @override
  void didUpdateWidget(_SelectorBuilder<S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newValue = widget.selector(widget.value);
    if (_selectedValue != newValue) {
      _selectedValue = newValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _selectedValue, widget.child);
  }
}

/// Callback debouncer for setState calls
class SetStateDebouncer {
  /// Creates a setState debouncer
  SetStateDebouncer({
    this.duration = const Duration(milliseconds: 16), // One frame at 60fps
  });

  /// Debounce duration
  final Duration duration;
  
  DateTime? _lastCall;
  bool _isPending = false;

  /// Run setState with debouncing
  void run(void Function() setState) {
    final now = DateTime.now();
    
    if (_lastCall == null || now.difference(_lastCall!) >= duration) {
      setState();
      _lastCall = now;
      _isPending = false;
    } else if (!_isPending) {
      _isPending = true;
      Future.delayed(
        duration - now.difference(_lastCall!),
        () {
          if (_isPending) {
            setState();
            _lastCall = DateTime.now();
            _isPending = false;
          }
        },
      );
    }
  }
}

/// Widget that caches its child and rebuilds only when key changes
class CachedWidget extends StatelessWidget {
  /// Creates a cached widget
  const CachedWidget({
    required this.cacheKey,
    required this.child,
    super.key,
  });

  /// Key for caching
  final Object cacheKey;
  
  /// Child widget to cache
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: ValueKey(cacheKey),
      child: child,
    );
  }
}

/// Optimized ListView that only builds visible items
class OptimizedListView extends StatelessWidget {
  /// Creates an optimized list view
  const OptimizedListView({
    required this.itemCount,
    required this.itemBuilder,
    this.itemExtent,
    this.cacheExtent = 250.0,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    super.key,
  });

  /// Number of items
  final int itemCount;
  
  /// Item builder
  final Widget Function(BuildContext context, int index) itemBuilder;
  
  /// Fixed item extent for better performance
  final double? itemExtent;
  
  /// Cache extent in pixels
  final double cacheExtent;
  
  /// Whether to wrap items in AutomaticKeepAlive
  final bool addAutomaticKeepAlives;
  
  /// Whether to add repaint boundaries
  final bool addRepaintBoundaries;
  
  /// Whether to add semantic indexes
  final bool addSemanticIndexes;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemExtent: itemExtent,
      cacheExtent: cacheExtent,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes,
      itemBuilder: (context, index) {
        return RepaintBoundary(
          child: itemBuilder(context, index),
        );
      },
    );
  }
}
