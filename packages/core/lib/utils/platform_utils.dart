/// Platform detection and optimization utilities
library platform_utils;

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

/// Platform detection utilities for cross-platform optimization
class PlatformUtils {
  const PlatformUtils._();

  /// Check if running on web
  static bool get isWeb => kIsWeb;

  /// Check if running on mobile (iOS or Android)
  static bool get isMobile => !kIsWeb && (Platform.isIOS || Platform.isAndroid);

  /// Check if running on desktop (Windows, macOS, or Linux)
  static bool get isDesktop =>
      !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);

  /// Check if running on iOS
  static bool get isIOS => !kIsWeb && Platform.isIOS;

  /// Check if running on Android
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;

  /// Check if running on Windows
  static bool get isWindows => !kIsWeb && Platform.isWindows;

  /// Check if running on macOS
  static bool get isMacOS => !kIsWeb && Platform.isMacOS;

  /// Check if running on Linux
  static bool get isLinux => !kIsWeb && Platform.isLinux;

  /// Get platform name as string
  static String get platformName {
    if (kIsWeb) return 'Web';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isLinux) return 'Linux';
    return 'Unknown';
  }

  /// Check if platform supports native isolates
  static bool get supportsIsolates => !kIsWeb;

  /// Check if platform has good file system access
  static bool get hasFileSystem => !kIsWeb;

  /// Get recommended cache size for platform (in MB)
  static int get recommendedCacheSize {
    if (isWeb) return 50; // Limited storage on web
    if (isMobile) return 100; // Moderate storage on mobile
    return 200; // More storage on desktop
  }

  /// Get recommended image cache count for platform
  static int get recommendedImageCacheCount {
    if (isWeb) return 500;
    if (isMobile) return 1000;
    return 2000;
  }

  /// Get recommended number of isolates for platform
  /// Note: Actual optimal count may vary based on device capabilities
  static int get recommendedIsolateCount {
    if (isWeb) return 0; // Web doesn't support isolates
    if (isMobile) return 2; // Conservative default for mobile
    return 4; // Conservative default for desktop
    // TODO: Consider using Platform.numberOfProcessors when available
  }

  /// Check if platform benefits from aggressive caching
  static bool get shouldUseAggressiveCaching {
    return isDesktop; // Desktop has more memory and storage
  }

  /// Check if platform has touch input
  static bool get hasTouchInput {
    return isMobile || isWeb;
  }

  /// Check if platform has mouse/trackpad
  static bool get hasPointerInput {
    return isDesktop || isWeb;
  }

  /// Get recommended debounce duration for platform
  static Duration get recommendedDebounceDuration {
    if (isMobile) {
      return const Duration(milliseconds: 300); // Slower on mobile
    }
    return const Duration(milliseconds: 200); // Faster on desktop
  }

  /// Get recommended throttle duration for platform
  static Duration get recommendedThrottleDuration {
    if (isMobile) {
      return const Duration(milliseconds: 150);
    }
    return const Duration(milliseconds: 100);
  }

  /// Check if platform benefits from lazy loading
  static bool get shouldUseLazyLoading {
    return true; // All platforms benefit from lazy loading
  }

  /// Get recommended page size for pagination
  static int get recommendedPageSize {
    if (isMobile) return 20; // Smaller pages on mobile
    if (isWeb) return 30; // Medium pages on web
    return 50; // Larger pages on desktop
  }

  /// Check if platform supports background processing
  static bool get supportsBackgroundProcessing {
    return !isWeb && (isIOS || isAndroid);
  }

  /// Get platform-specific configuration
  static PlatformConfig get config {
    return PlatformConfig(
      cacheSize: recommendedCacheSize,
      imageCacheCount: recommendedImageCacheCount,
      isolateCount: recommendedIsolateCount,
      debounceDuration: recommendedDebounceDuration,
      throttleDuration: recommendedThrottleDuration,
      pageSize: recommendedPageSize,
      useAggressiveCaching: shouldUseAggressiveCaching,
      useLazyLoading: shouldUseLazyLoading,
      supportsIsolates: supportsIsolates,
    );
  }
}

/// Platform-specific configuration
class PlatformConfig {
  /// Creates a platform configuration
  const PlatformConfig({
    required this.cacheSize,
    required this.imageCacheCount,
    required this.isolateCount,
    required this.debounceDuration,
    required this.throttleDuration,
    required this.pageSize,
    required this.useAggressiveCaching,
    required this.useLazyLoading,
    required this.supportsIsolates,
  });

  /// Recommended cache size in MB
  final int cacheSize;

  /// Recommended image cache count
  final int imageCacheCount;

  /// Recommended number of isolates
  final int isolateCount;

  /// Recommended debounce duration
  final Duration debounceDuration;

  /// Recommended throttle duration
  final Duration throttleDuration;

  /// Recommended page size for pagination
  final int pageSize;

  /// Whether to use aggressive caching
  final bool useAggressiveCaching;

  /// Whether to use lazy loading
  final bool useLazyLoading;

  /// Whether platform supports isolates
  final bool supportsIsolates;

  @override
  String toString() {
    return '''
PlatformConfig:
  Cache Size: ${cacheSize}MB
  Image Cache Count: $imageCacheCount
  Isolate Count: $isolateCount
  Debounce Duration: ${debounceDuration.inMilliseconds}ms
  Throttle Duration: ${throttleDuration.inMilliseconds}ms
  Page Size: $pageSize
  Aggressive Caching: $useAggressiveCaching
  Lazy Loading: $useLazyLoading
  Supports Isolates: $supportsIsolates
''';
  }
}

/// Device capability detection
class DeviceCapabilities {
  const DeviceCapabilities._();

  /// Estimate device performance tier
  /// Returns: 'high', 'medium', or 'low'
  static String estimatePerformanceTier() {
    // This is a simple heuristic based on platform
    // In a real app, you might want to benchmark on startup
    if (PlatformUtils.isDesktop) return 'high';
    if (PlatformUtils.isWeb) return 'medium';
    // For mobile, we assume medium by default
    // Could be enhanced with actual device info
    return 'medium';
  }

  /// Get recommended settings for device tier
  static DeviceSettings getRecommendedSettings() {
    final tier = estimatePerformanceTier();

    switch (tier) {
      case 'high':
        return const DeviceSettings(
          enableAnimations: true,
          enableShadows: true,
          enableBlur: true,
          maxConcurrentOperations: 4,
          useHighQualityImages: true,
        );
      case 'medium':
        return const DeviceSettings(
          enableAnimations: true,
          enableShadows: true,
          enableBlur: false,
          maxConcurrentOperations: 2,
          useHighQualityImages: true,
        );
      case 'low':
        return const DeviceSettings(
          enableAnimations: false,
          enableShadows: false,
          enableBlur: false,
          maxConcurrentOperations: 1,
          useHighQualityImages: false,
        );
      default:
        return const DeviceSettings(
          enableAnimations: true,
          enableShadows: true,
          enableBlur: false,
          maxConcurrentOperations: 2,
          useHighQualityImages: true,
        );
    }
  }
}

/// Device-specific settings
class DeviceSettings {
  /// Creates device settings
  const DeviceSettings({
    required this.enableAnimations,
    required this.enableShadows,
    required this.enableBlur,
    required this.maxConcurrentOperations,
    required this.useHighQualityImages,
  });

  /// Whether to enable animations
  final bool enableAnimations;

  /// Whether to enable shadows
  final bool enableShadows;

  /// Whether to enable blur effects
  final bool enableBlur;

  /// Maximum concurrent operations
  final int maxConcurrentOperations;

  /// Whether to use high quality images
  final bool useHighQualityImages;
}
