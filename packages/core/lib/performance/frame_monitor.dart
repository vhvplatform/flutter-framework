/// Frame rate monitoring utilities
library frame_monitor;

import 'dart:async';
import 'package:flutter/scheduler.dart';
import '../utils/app_logger.dart';

/// Monitor frame rate and detect jank
class FrameRateMonitor {
  FrameRateMonitor._();

  static final FrameRateMonitor _instance = FrameRateMonitor._();
  
  /// Singleton instance
  static FrameRateMonitor get instance => _instance;

  final List<Duration> _frameDurations = [];
  DateTime? _lastFrameTime;
  bool _isMonitoring = false;
  Timer? _reportTimer;
  static const int _maxFrameSamples = 60; // Limit memory usage

  /// Start monitoring frame rate
  void startMonitoring({
    Duration reportInterval = const Duration(seconds: 5),
  }) {
    if (_isMonitoring) return;

    _isMonitoring = true;
    _frameDurations.clear();
    _lastFrameTime = DateTime.now();

    SchedulerBinding.instance.addPostFrameCallback(_onFrame);

    _reportTimer = Timer.periodic(reportInterval, (_) {
      _printReport();
    });
  }

  /// Stop monitoring
  void stopMonitoring() {
    _isMonitoring = false;
    _reportTimer?.cancel();
    _reportTimer = null;
    _frameDurations.clear();
  }

  void _onFrame(Duration timestamp) {
    if (!_isMonitoring) return;

    final now = DateTime.now();
    if (_lastFrameTime != null) {
      final frameDuration = now.difference(_lastFrameTime!);
      _frameDurations.add(frameDuration);

      // Keep only last N frames to prevent memory bloat
      if (_frameDurations.length > _maxFrameSamples) {
        _frameDurations.removeAt(0);
      }

      // Detect jank (frame took > 16.67ms for 60fps)
      // Only log occasionally to avoid log spam
      if (frameDuration.inMilliseconds > 16 && _frameDurations.length % 10 == 0) {
        AppLogger.instance.warning(
          'Frame jank detected',
          context: {
            'duration_ms': frameDuration.inMilliseconds.toString(),
            'target_ms': '16',
          },
        );
      }
    }

    _lastFrameTime = now;
    SchedulerBinding.instance.addPostFrameCallback(_onFrame);
  }

  void _printReport() {
    if (_frameDurations.isEmpty) return;

    final avgMs = _frameDurations
            .fold<int>(0, (sum, d) => sum + d.inMilliseconds) /
        _frameDurations.length;

    final fps = 1000 / avgMs;
    
    final jankCount = _frameDurations
        .where((d) => d.inMilliseconds > 16)
        .length;

    AppLogger.instance.info(
      'Frame Rate Report',
      context: {
        'avg_frame_time_ms': avgMs.toStringAsFixed(2),
        'fps': fps.toStringAsFixed(1),
        'jank_frames': jankCount.toString(),
        'total_frames': _frameDurations.length.toString(),
      },
    );
  }

  /// Get current average FPS
  double get currentFps {
    if (_frameDurations.isEmpty) return 0;

    final avgMs = _frameDurations
            .fold<int>(0, (sum, d) => sum + d.inMilliseconds) /
        _frameDurations.length;

    return 1000 / avgMs;
  }

  /// Get jank percentage
  double get jankPercentage {
    if (_frameDurations.isEmpty) return 0;

    final jankCount = _frameDurations
        .where((d) => d.inMilliseconds > 16)
        .length;

    return (jankCount / _frameDurations.length) * 100;
  }
}

/// Widget that reports slow builds
class BuildTimeTracker extends StatefulWidget {
  /// Creates a build time tracker
  const BuildTimeTracker({
    required this.child,
    required this.name,
    this.warnThresholdMs = 16,
    super.key,
  });

  /// Child widget
  final Widget child;
  
  /// Name for tracking
  final String name;
  
  /// Warning threshold in milliseconds
  final int warnThresholdMs;

  @override
  State<BuildTimeTracker> createState() => _BuildTimeTrackerState();
}

class _BuildTimeTrackerState extends State<BuildTimeTracker> {
  @override
  Widget build(BuildContext context) {
    final startTime = DateTime.now();
    
    final child = widget.child;
    
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final buildTime = DateTime.now().difference(startTime);
      
      if (buildTime.inMilliseconds > widget.warnThresholdMs) {
        AppLogger.instance.warning(
          'Slow build detected',
          context: {
            'widget': widget.name,
            'build_time_ms': buildTime.inMilliseconds.toString(),
            'threshold_ms': widget.warnThresholdMs.toString(),
          },
        );
      }
    });

    return child;
  }
}
