/// App startup performance tracking
library startup_tracker;

import 'package:flutter/foundation.dart';
import '../utils/app_logger.dart';

/// Track app startup performance
class StartupTracker {
  StartupTracker._();

  static final StartupTracker _instance = StartupTracker._();
  
  /// Singleton instance
  static StartupTracker get instance => _instance;

  final Map<String, DateTime> _milestones = {};
  DateTime? _appStartTime;

  /// Mark app start
  void markAppStart() {
    _appStartTime = DateTime.now();
    _milestones['app_start'] = _appStartTime!;
  }

  /// Mark a milestone
  void markMilestone(String name) {
    _milestones[name] = DateTime.now();
    
    if (_appStartTime != null) {
      final elapsed = DateTime.now().difference(_appStartTime!);
      if (kDebugMode) {
        AppLogger.instance.debug(
          'Startup milestone',
          context: {
            'milestone': name,
            'elapsed_ms': elapsed.inMilliseconds.toString(),
          },
        );
      }
    }
  }

  /// Get time between two milestones
  Duration? getTimeBetween(String start, String end) {
    final startTime = _milestones[start];
    final endTime = _milestones[end];
    
    if (startTime == null || endTime == null) return null;
    
    return endTime.difference(startTime);
  }

  /// Get time from app start to milestone
  Duration? getTimeFromStart(String milestone) {
    if (_appStartTime == null) return null;
    
    final milestoneTime = _milestones[milestone];
    if (milestoneTime == null) return null;
    
    return milestoneTime.difference(_appStartTime!);
  }

  /// Print startup report
  void printReport() {
    if (_appStartTime == null) {
      AppLogger.instance.warning('No startup data available');
      return;
    }

    AppLogger.instance.info('=== Startup Performance Report ===');
    
    final sortedMilestones = _milestones.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    for (var i = 0; i < sortedMilestones.length; i++) {
      final milestone = sortedMilestones[i];
      final elapsed = milestone.value.difference(_appStartTime!);
      
      AppLogger.instance.info(
        '${milestone.key}: +${elapsed.inMilliseconds}ms',
      );
    }

    final totalTime = DateTime.now().difference(_appStartTime!);
    AppLogger.instance.info('Total startup time: ${totalTime.inMilliseconds}ms');
  }

  /// Clear all data
  void clear() {
    _milestones.clear();
    _appStartTime = null;
  }

  /// Get all milestones
  Map<String, Duration> getAllMilestones() {
    if (_appStartTime == null) return {};
    
    return Map.fromEntries(
      _milestones.entries.map(
        (e) => MapEntry(
          e.key,
          e.value.difference(_appStartTime!),
        ),
      ),
    );
  }
}

/// Common startup milestones
class StartupMilestones {
  const StartupMilestones._();
  
  static const String appStart = 'app_start';
  static const String configLoaded = 'config_loaded';
  static const String diInitialized = 'di_initialized';
  static const String authInitialized = 'auth_initialized';
  static const String modulesRegistered = 'modules_registered';
  static const String modulesInitialized = 'modules_initialized';
  static const String firstFrameRendered = 'first_frame_rendered';
  static const String homeScreenLoaded = 'home_screen_loaded';
}
