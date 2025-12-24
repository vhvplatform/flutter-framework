/// Memory management utilities
library memory;

import 'dart:async';
import 'package:flutter/foundation.dart';
import '../utils/app_logger.dart';

/// Memory manager for monitoring and managing app memory
class MemoryManager {
  MemoryManager._();

  static final MemoryManager _instance = MemoryManager._();
  
  /// Singleton instance
  static MemoryManager get instance => _instance;

  final List<WeakReference<Object>> _trackedObjects = [];
  Timer? _gcTimer;

  /// Start tracking an object for memory leaks
  void trackObject(Object object, String tag) {
    if (kDebugMode) {
      _trackedObjects.add(WeakReference(object));
      AppLogger.instance.debug('Tracking object: $tag');
    }
  }

  /// Start periodic garbage collection check
  void startGCMonitoring({Duration interval = const Duration(minutes: 1)}) {
    if (kDebugMode) {
      _gcTimer?.cancel();
      _gcTimer = Timer.periodic(interval, (_) {
        _checkTrackedObjects();
      });
    }
  }

  /// Stop garbage collection monitoring
  void stopGCMonitoring() {
    _gcTimer?.cancel();
  }

  void _checkTrackedObjects() {
    final alive = _trackedObjects.where((ref) => ref.target != null).length;
    final dead = _trackedObjects.length - alive;

    if (dead > 0) {
      AppLogger.instance.info(
        'GC Check: $alive alive, $dead collected',
      );
    }

    // Remove dead references
    _trackedObjects.removeWhere((ref) => ref.target == null);
  }

  /// Force garbage collection (debug only)
  void forceGC() {
    if (kDebugMode) {
      AppLogger.instance.debug('Requesting garbage collection');
      // Note: Dart doesn't provide direct GC control
      // This is just a marker for profiling
    }
  }

  /// Clear all tracked objects
  void clearTracking() {
    _trackedObjects.clear();
  }

  /// Get count of currently tracked objects
  int get trackedObjectCount => _trackedObjects.length;
}

/// Mixin for disposable objects
mixin Disposable {
  bool _isDisposed = false;

  /// Whether this object has been disposed
  bool get isDisposed => _isDisposed;

  /// Dispose this object and free resources
  void dispose() {
    if (_isDisposed) {
      AppLogger.instance.warning(
        'Attempting to dispose already disposed object: ${runtimeType}',
      );
      return;
    }
    _isDisposed = true;
    onDispose();
  }

  /// Override this method to perform cleanup
  void onDispose();

  /// Ensure object is not disposed before using
  void checkNotDisposed() {
    if (_isDisposed) {
      throw StateError('Cannot use disposed object: ${runtimeType}');
    }
  }
}
