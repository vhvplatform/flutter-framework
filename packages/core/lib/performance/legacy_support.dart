/// Legacy device support and optimization utilities
library legacy_support;

import 'dart:async';
import 'package:flutter/foundation.dart';
import '../utils/platform_utils.dart';

/// Support utilities for older and lower-end devices
class LegacyDeviceSupport {
  const LegacyDeviceSupport._();

  /// Check if running on a likely older/slower device
  /// This is a heuristic that can be improved with actual device detection
  static bool get isLikelyOlderDevice {
    // Web can't easily detect device age
    if (PlatformUtils.isWeb) return false;
    
    // Desktop devices are typically powerful
    if (PlatformUtils.isDesktop) return false;
    
    // Mobile - we need runtime detection
    // This should be enhanced with actual device info when available
    return false; // Default to assuming modern device
  }

  /// Get optimized settings for older devices
  static LegacyDeviceConfig getOptimizedConfig() {
    return const LegacyDeviceConfig(
      reduceAnimationDuration: true,
      simplifyAnimations: true,
      disableHeavyEffects: true,
      aggressiveMemoryManagement: true,
      reducedCacheSize: true,
      lowerImageQuality: true,
      disableBackgroundProcessing: true,
      reduceNetworkConcurrency: true,
    );
  }

  /// Get performance-conscious configuration
  static PerformanceConfig getPerformanceConfig({
    required bool isOlderDevice,
  }) {
    if (isOlderDevice) {
      return const PerformanceConfig(
        maxCacheEntries: 50,
        maxImageCacheSize: 30, // 30MB
        maxImageCacheCount: 300,
        maxConcurrentNetworkRequests: 2,
        frameRateTarget: 30, // Lower target for stability
        enablePerformanceMonitoring: true,
        useAggressiveGC: true,
      );
    } else {
      return PerformanceConfig(
        maxCacheEntries: 100,
        maxImageCacheSize: PlatformUtils.recommendedCacheSize,
        maxImageCacheCount: PlatformUtils.recommendedImageCacheCount,
        maxConcurrentNetworkRequests: 4,
        frameRateTarget: 60,
        enablePerformanceMonitoring: kDebugMode,
        useAggressiveGC: false,
      );
    }
  }
}

/// Configuration for legacy/older devices
class LegacyDeviceConfig {
  /// Creates a legacy device configuration
  const LegacyDeviceConfig({
    required this.reduceAnimationDuration,
    required this.simplifyAnimations,
    required this.disableHeavyEffects,
    required this.aggressiveMemoryManagement,
    required this.reducedCacheSize,
    required this.lowerImageQuality,
    required this.disableBackgroundProcessing,
    required this.reduceNetworkConcurrency,
  });

  /// Reduce animation durations for faster completion
  final bool reduceAnimationDuration;

  /// Simplify complex animations
  final bool simplifyAnimations;

  /// Disable heavy effects like blur, shadows on large surfaces
  final bool disableHeavyEffects;

  /// Use aggressive memory management and cleanup
  final bool aggressiveMemoryManagement;

  /// Use smaller cache sizes
  final bool reducedCacheSize;

  /// Use lower quality images
  final bool lowerImageQuality;

  /// Disable non-essential background processing
  final bool disableBackgroundProcessing;

  /// Reduce concurrent network requests
  final bool reduceNetworkConcurrency;

  /// Get animation duration multiplier
  double get animationDurationMultiplier =>
      reduceAnimationDuration ? 0.7 : 1.0;

  /// Get cache size multiplier
  double get cacheSizeMultiplier => reducedCacheSize ? 0.5 : 1.0;

  /// Get image quality multiplier (0.5-1.0)
  double get imageQualityMultiplier => lowerImageQuality ? 0.7 : 1.0;
}

/// Performance configuration
class PerformanceConfig {
  /// Creates a performance configuration
  const PerformanceConfig({
    required this.maxCacheEntries,
    required this.maxImageCacheSize,
    required this.maxImageCacheCount,
    required this.maxConcurrentNetworkRequests,
    required this.frameRateTarget,
    required this.enablePerformanceMonitoring,
    required this.useAggressiveGC,
  });

  /// Maximum cache entries per operation
  final int maxCacheEntries;

  /// Maximum image cache size in MB
  final int maxImageCacheSize;

  /// Maximum number of cached images
  final int maxImageCacheCount;

  /// Maximum concurrent network requests
  final int maxConcurrentNetworkRequests;

  /// Target frame rate (30 or 60 FPS)
  final int frameRateTarget;

  /// Enable performance monitoring
  final bool enablePerformanceMonitoring;

  /// Use aggressive garbage collection
  final bool useAggressiveGC;

  /// Get target frame time in milliseconds
  int get targetFrameTimeMs => 1000 ~/ frameRateTarget;
}

/// Performance degradation detector
class PerformanceDegradationDetector {
  PerformanceDegradationDetector._();

  static final PerformanceDegradationDetector _instance =
      PerformanceDegradationDetector._();

  /// Singleton instance
  static PerformanceDegradationDetector get instance => _instance;

  final List<double> _fpsHistory = [];
  final List<int> _memoryHistory = [];
  Timer? _monitorTimer;
  bool _isMonitoring = false;
  bool _degradationDetected = false;

  /// Start monitoring for performance degradation
  void startMonitoring({
    Duration checkInterval = const Duration(seconds: 30),
  }) {
    if (_isMonitoring) return;

    _isMonitoring = true;
    _fpsHistory.clear();
    _memoryHistory.clear();
    _degradationDetected = false;

    _monitorTimer = Timer.periodic(checkInterval, (_) {
      _checkPerformance();
    });
  }

  /// Stop monitoring
  void stopMonitoring() {
    _isMonitoring = false;
    _monitorTimer?.cancel();
    _monitorTimer = null;
  }

  void _checkPerformance() {
    // This would integrate with FrameRateMonitor and MemoryManager
    // For now, this is a placeholder for the monitoring logic
    
    // Check FPS history for degradation
    if (_fpsHistory.length > 5) {
      final avgFps = _fpsHistory.reduce((a, b) => a + b) / _fpsHistory.length;
      if (avgFps < 40 && !_degradationDetected) {
        _degradationDetected = true;
        _onDegradationDetected();
      }
    }
  }

  void _onDegradationDetected() {
    if (kDebugMode) {
      debugPrint('⚠️ Performance degradation detected. Consider:');
      debugPrint('  - Reducing cache sizes');
      debugPrint('  - Disabling heavy animations');
      debugPrint('  - Lowering image quality');
      debugPrint('  - Reducing concurrent operations');
    }
  }

  /// Record FPS sample
  void recordFps(double fps) {
    _fpsHistory.add(fps);
    if (_fpsHistory.length > 10) {
      _fpsHistory.removeAt(0);
    }
  }

  /// Record memory usage in MB
  void recordMemory(int memoryMB) {
    _memoryHistory.add(memoryMB);
    if (_memoryHistory.length > 10) {
      _memoryHistory.removeAt(0);
    }
  }

  /// Check if degradation was detected
  bool get isDegraded => _degradationDetected;

  /// Get recommended actions
  List<String> getRecommendedActions() {
    final actions = <String>[];

    if (_degradationDetected) {
      final avgFps = _fpsHistory.isEmpty
          ? 60.0
          : _fpsHistory.reduce((a, b) => a + b) / _fpsHistory.length;

      if (avgFps < 30) {
        actions.add('Critical: FPS below 30. Reduce animations and effects.');
      } else if (avgFps < 45) {
        actions.add('Warning: FPS below 45. Consider simplifying UI.');
      }

      if (_memoryHistory.isNotEmpty) {
        final avgMemory =
            _memoryHistory.reduce((a, b) => a + b) / _memoryHistory.length;
        if (avgMemory > 200) {
          actions.add('High memory usage. Clear caches and reduce image sizes.');
        }
      }
    }

    return actions;
  }

  /// Reset degradation state
  void reset() {
    _degradationDetected = false;
    _fpsHistory.clear();
    _memoryHistory.clear();
  }
}

/// Adaptive performance manager that adjusts settings based on runtime performance
class AdaptivePerformanceManager {
  AdaptivePerformanceManager._();

  static final AdaptivePerformanceManager _instance =
      AdaptivePerformanceManager._();

  /// Singleton instance
  static AdaptivePerformanceManager get instance => _instance;

  PerformanceConfig _currentConfig = const PerformanceConfig(
    maxCacheEntries: 100,
    maxImageCacheSize: 100,
    maxImageCacheCount: 1000,
    maxConcurrentNetworkRequests: 4,
    frameRateTarget: 60,
    enablePerformanceMonitoring: false,
    useAggressiveGC: false,
  );

  bool _adaptiveMode = false;

  /// Enable adaptive performance mode
  void enableAdaptiveMode({
    bool isOlderDevice = false,
  }) {
    _adaptiveMode = true;
    _currentConfig = LegacyDeviceSupport.getPerformanceConfig(
      isOlderDevice: isOlderDevice,
    );

    if (kDebugMode) {
      debugPrint('📊 Adaptive Performance Mode enabled');
      debugPrint('   Frame Target: ${_currentConfig.frameRateTarget} FPS');
      debugPrint('   Cache Size: ${_currentConfig.maxImageCacheSize}MB');
      debugPrint('   Max Concurrent Requests: ${_currentConfig.maxConcurrentNetworkRequests}');
    }

    PerformanceDegradationDetector.instance.startMonitoring();
  }

  /// Disable adaptive mode
  void disableAdaptiveMode() {
    _adaptiveMode = false;
    PerformanceDegradationDetector.instance.stopMonitoring();
  }

  /// Get current performance configuration
  PerformanceConfig get currentConfig => _currentConfig;

  /// Check if in adaptive mode
  bool get isAdaptive => _adaptiveMode;

  /// Adjust settings based on detected performance
  void adjustForPerformance() {
    if (!_adaptiveMode) return;

    if (PerformanceDegradationDetector.instance.isDegraded) {
      // Downgrade to more conservative settings
      _currentConfig = const PerformanceConfig(
        maxCacheEntries: 50,
        maxImageCacheSize: 30,
        maxImageCacheCount: 300,
        maxConcurrentNetworkRequests: 2,
        frameRateTarget: 30,
        enablePerformanceMonitoring: true,
        useAggressiveGC: true,
      );

      if (kDebugMode) {
        debugPrint('⚡ Performance settings adjusted for better stability');
      }
    }
  }
}
