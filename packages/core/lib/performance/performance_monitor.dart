/// Performance monitoring utilities
library performance;

import 'dart:async';
import 'package:flutter/foundation.dart';
import '../utils/app_logger.dart';

/// Performance monitor for tracking app performance
class PerformanceMonitor {
  PerformanceMonitor._();

  static final PerformanceMonitor _instance = PerformanceMonitor._();
  
  /// Singleton instance
  static PerformanceMonitor get instance => _instance;

  final Map<String, DateTime> _startTimes = {};
  final Map<String, List<Duration>> _metrics = {};
  static const int _maxMetricsPerOperation = 100; // Limit memory usage

  /// Start timing an operation
  void startTimer(String operation) {
    _startTimes[operation] = DateTime.now();
  }

  /// Stop timing an operation and log the duration
  void stopTimer(String operation) {
    final startTime = _startTimes[operation];
    if (startTime == null) {
      AppLogger.instance.warning(
        'No start time found for operation: $operation',
      );
      return;
    }

    final duration = DateTime.now().difference(startTime);
    _startTimes.remove(operation);

    // Store metric with size limit to prevent memory bloat
    final metrics = _metrics.putIfAbsent(operation, () => []);
    metrics.add(duration);
    
    // Keep only recent metrics to avoid unbounded memory growth
    if (metrics.length > _maxMetricsPerOperation) {
      metrics.removeAt(0);
    }

    // Log if operation took too long (> 100ms)
    if (duration.inMilliseconds > 100) {
      AppLogger.instance.warning(
        'Slow operation detected',
        context: {
          'operation': operation,
          'duration_ms': duration.inMilliseconds.toString(),
        },
      );
    } else if (kDebugMode) {
      AppLogger.instance.debug(
        'Operation completed',
        context: {
          'operation': operation,
          'duration_ms': duration.inMilliseconds.toString(),
        },
      );
    }
  }

  /// Measure an async operation
  Future<T> measure<T>(
    String operation,
    Future<T> Function() function,
  ) async {
    startTimer(operation);
    try {
      return await function();
    } finally {
      stopTimer(operation);
    }
  }

  /// Measure a sync operation
  T measureSync<T>(
    String operation,
    T Function() function,
  ) {
    startTimer(operation);
    try {
      return function();
    } finally {
      stopTimer(operation);
    }
  }

  /// Get average duration for an operation
  Duration? getAverageDuration(String operation) {
    final durations = _metrics[operation];
    if (durations == null || durations.isEmpty) return null;

    final totalMs = durations.fold<int>(
      0,
      (sum, d) => sum + d.inMilliseconds,
    );
    return Duration(milliseconds: totalMs ~/ durations.length);
  }

  /// Get all metrics
  Map<String, Duration?> getAllAverages() {
    final result = <String, Duration?>{};
    for (final operation in _metrics.keys) {
      result[operation] = getAverageDuration(operation);
    }
    return result;
  }

  /// Clear all metrics
  void clearMetrics() {
    _metrics.clear();
    _startTimes.clear();
  }

  /// Print performance report
  void printReport() {
    if (_metrics.isEmpty) {
      AppLogger.instance.info('No performance metrics available');
      return;
    }

    AppLogger.instance.info('=== Performance Report ===');
    final averages = getAllAverages();
    
    final sortedOperations = averages.keys.toList()
      ..sort((a, b) {
        final aDuration = averages[a]?.inMilliseconds ?? 0;
        final bDuration = averages[b]?.inMilliseconds ?? 0;
        return bDuration.compareTo(aDuration);
      });

    for (final operation in sortedOperations) {
      final avg = averages[operation];
      final count = _metrics[operation]?.length ?? 0;
      AppLogger.instance.info(
        '$operation: ${avg?.inMilliseconds ?? 0}ms (avg over $count calls)',
      );
    }
  }
}
