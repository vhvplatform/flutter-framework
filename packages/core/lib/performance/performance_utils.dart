/// Performance utilities and helpers
library performance_utils;

import 'dart:async';
import 'package:flutter/foundation.dart';

/// Performance benchmark result
class BenchmarkResult {
  /// Creates a benchmark result
  const BenchmarkResult({
    required this.name,
    required this.iterations,
    required this.totalDuration,
    required this.averageDuration,
    required this.minDuration,
    required this.maxDuration,
  });

  /// Benchmark name
  final String name;

  /// Number of iterations
  final int iterations;

  /// Total duration
  final Duration totalDuration;

  /// Average duration per iteration
  final Duration averageDuration;

  /// Minimum duration
  final Duration minDuration;

  /// Maximum duration
  final Duration maxDuration;

  /// Format result as string
  String format() {
    return '''
Benchmark: $name
Iterations: $iterations
Total: ${totalDuration.inMilliseconds}ms
Average: ${averageDuration.inMicroseconds}μs
Min: ${minDuration.inMicroseconds}μs
Max: ${maxDuration.inMicroseconds}μs
''';
  }
}

/// Benchmark utilities
class PerformanceBenchmark {
  const PerformanceBenchmark._();

  /// Run a synchronous benchmark
  static BenchmarkResult benchmarkSync(
    String name,
    void Function() function, {
    int iterations = 100,
    int warmupIterations = 10,
  }) {
    // Warmup
    for (var i = 0; i < warmupIterations; i++) {
      function();
    }

    final durations = <Duration>[];
    final startTime = DateTime.now();

    for (var i = 0; i < iterations; i++) {
      final iterStart = DateTime.now();
      function();
      final iterEnd = DateTime.now();
      durations.add(iterEnd.difference(iterStart));
    }

    final endTime = DateTime.now();
    final totalDuration = endTime.difference(startTime);

    durations.sort((a, b) => a.compareTo(b));

    final avgMicros = totalDuration.inMicroseconds ~/ iterations;

    return BenchmarkResult(
      name: name,
      iterations: iterations,
      totalDuration: totalDuration,
      averageDuration: Duration(microseconds: avgMicros),
      minDuration: durations.first,
      maxDuration: durations.last,
    );
  }

  /// Run an asynchronous benchmark
  static Future<BenchmarkResult> benchmarkAsync(
    String name,
    Future<void> Function() function, {
    int iterations = 100,
    int warmupIterations = 10,
  }) async {
    // Warmup
    for (var i = 0; i < warmupIterations; i++) {
      await function();
    }

    final durations = <Duration>[];
    final startTime = DateTime.now();

    for (var i = 0; i < iterations; i++) {
      final iterStart = DateTime.now();
      await function();
      final iterEnd = DateTime.now();
      durations.add(iterEnd.difference(iterStart));
    }

    final endTime = DateTime.now();
    final totalDuration = endTime.difference(startTime);

    durations.sort((a, b) => a.compareTo(b));

    final avgMicros = totalDuration.inMicroseconds ~/ iterations;

    return BenchmarkResult(
      name: name,
      iterations: iterations,
      totalDuration: totalDuration,
      averageDuration: Duration(microseconds: avgMicros),
      minDuration: durations.first,
      maxDuration: durations.last,
    );
  }

  /// Compare multiple benchmarks
  static void compareBenchmarks(List<BenchmarkResult> results) {
    if (results.isEmpty) return;

    debugPrint('=== Benchmark Comparison ===');
    
    // Sort by average duration
    final sorted = List<BenchmarkResult>.from(results)
      ..sort((a, b) => a.averageDuration.compareTo(b.averageDuration));

    final fastest = sorted.first;

    for (final result in sorted) {
      final ratio = result.averageDuration.inMicroseconds /
          fastest.averageDuration.inMicroseconds;
      
      debugPrint('${result.name}:');
      debugPrint('  Avg: ${result.averageDuration.inMicroseconds}μs');
      debugPrint('  Relative: ${ratio.toStringAsFixed(2)}x');
    }
  }
}

/// Memory size utilities
class MemorySize {
  const MemorySize._();

  /// Format bytes to human readable string
  static String format(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    }
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  /// Convert KB to bytes
  static int fromKB(int kb) => kb * 1024;

  /// Convert MB to bytes
  static int fromMB(int mb) => mb * 1024 * 1024;

  /// Convert GB to bytes
  static int fromGB(int gb) => gb * 1024 * 1024 * 1024;
}

/// FPS (Frames Per Second) utilities
class FPSUtils {
  const FPSUtils._();

  /// Target FPS for 60Hz displays
  static const int target60FPS = 60;

  /// Target FPS for 120Hz displays
  static const int target120FPS = 120;

  /// Target frame time for 60 FPS in milliseconds
  static const int target60FrameTimeMs = 16;

  /// Target frame time for 120 FPS in milliseconds
  static const int target120FrameTimeMs = 8;

  /// Calculate FPS from frame duration
  static double calculateFPS(Duration frameDuration) {
    if (frameDuration.inMicroseconds == 0) return 0;
    return 1000000 / frameDuration.inMicroseconds;
  }

  /// Check if frame time is acceptable for target FPS
  static bool isFrameTimeAcceptable(
    Duration frameDuration,
    int targetFPS,
  ) {
    final targetFrameTime = Duration(microseconds: 1000000 ~/ targetFPS);
    return frameDuration <= targetFrameTime;
  }

  /// Calculate jank percentage from frame durations
  static double calculateJankPercentage(
    List<Duration> frameDurations,
    int targetFPS,
  ) {
    if (frameDurations.isEmpty) return 0;

    final targetFrameTime = Duration(microseconds: 1000000 ~/ targetFPS);
    final jankFrames = frameDurations
        .where((d) => d > targetFrameTime)
        .length;

    return (jankFrames / frameDurations.length) * 100;
  }
}

/// Performance tips and recommendations
class PerformanceTips {
  const PerformanceTips._();

  /// Get performance tips based on metrics
  static List<String> getTips({
    double? fps,
    double? jankPercentage,
    int? memoryUsageMB,
    Duration? startupTime,
  }) {
    final tips = <String>[];

    if (fps != null && fps < 55) {
      tips.add('Low FPS detected ($fps). Consider:');
      tips.add('  - Reducing widget rebuilds with const constructors');
      tips.add('  - Using RepaintBoundary for complex widgets');
      tips.add('  - Implementing lazy loading for long lists');
    }

    if (jankPercentage != null && jankPercentage > 5) {
      tips.add('High jank detected ($jankPercentage%). Consider:');
      tips.add('  - Moving heavy computations to isolates');
      tips.add('  - Debouncing/throttling frequent operations');
      tips.add('  - Reducing widget tree depth');
    }

    if (memoryUsageMB != null && memoryUsageMB > 200) {
      tips.add('High memory usage ($memoryUsageMB MB). Consider:');
      tips.add('  - Implementing proper dispose() methods');
      tips.add('  - Using image caching with size limits');
      tips.add('  - Checking for memory leaks with MemoryManager');
    }

    if (startupTime != null && startupTime.inSeconds > 3) {
      tips.add('Slow startup (${startupTime.inSeconds}s). Consider:');
      tips.add('  - Deferring non-critical initializations');
      tips.add('  - Using lazy initialization patterns');
      tips.add('  - Parallelizing independent startup tasks');
    }

    if (tips.isEmpty) {
      tips.add('Performance looks good! Keep up the optimization work.');
    }

    return tips;
  }
}
