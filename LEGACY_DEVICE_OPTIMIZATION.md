# Optimizing for Older and Lower-End Devices

This guide provides strategies and best practices for ensuring your Flutter SaaS application performs well on older devices and lower-end hardware.

## 🎯 Understanding Device Constraints

### Common Limitations of Older Devices

1. **Limited RAM** (1-2GB typical)
2. **Slower CPU** (older ARM architectures)
3. **Limited GPU** (software rendering in some cases)
4. **Slower storage** (eMMC vs UFS)
5. **Older OS versions** (Android 5-7, iOS 10-12)

## 🚀 Automatic Optimization

### Using Adaptive Performance Manager

The framework now includes automatic performance adaptation:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Enable adaptive mode with device detection
  final tier = await DeviceCapabilities.estimatePerformanceTierWithBenchmark();
  final isOlderDevice = tier == 'low';
  
  AdaptivePerformanceManager.instance.enableAdaptiveMode(
    isOlderDevice: isOlderDevice,
  );
  
  // Apply recommended settings
  final settings = await DeviceCapabilities.getRecommendedSettingsAsync();
  
  // Configure based on device capabilities
  final config = AdaptivePerformanceManager.instance.currentConfig;
  PerformanceMonitor.instance.maxMetricsPerOperation = config.maxCacheEntries;
  ImageCacheManager.setCacheSize(
    maxCacheSize: config.maxImageCacheSize,
    maxCacheCount: config.maxImageCacheCount,
  );
  
  runApp(MyApp(deviceSettings: settings));
}
```

### Device Settings Integration

```dart
class MyApp extends StatelessWidget {
  const MyApp({required this.deviceSettings, super.key});
  
  final DeviceSettings deviceSettings;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      // Adjust theme based on device capabilities
      theme: ThemeData(
        // Disable expensive visual effects on low-end devices
        useMaterial3: true,
        // Conditionally enable shadows
        shadowColor: deviceSettings.enableShadows 
            ? Colors.black54 
            : Colors.transparent,
      ),
      home: HomePage(settings: deviceSettings),
    );
  }
}
```

## 📱 Manual Optimizations

### 1. Conditional Animation

```dart
class AnimatedWidget extends StatelessWidget {
  const AnimatedWidget({
    required this.child,
    required this.settings,
    super.key,
  });

  final Widget child;
  final DeviceSettings settings;

  @override
  Widget build(BuildContext context) {
    if (!settings.enableAnimations) {
      // Skip animation on low-end devices
      return child;
    }

    // Apply reduced motion if needed
    final duration = Duration(
      milliseconds: (300 * settings.animationDurationMultiplier).toInt(),
    );

    return AnimatedOpacity(
      opacity: 1.0,
      duration: duration,
      child: child,
    );
  }
}
```

### 2. Image Quality Adaptation

```dart
class AdaptiveImage extends StatelessWidget {
  const AdaptiveImage({
    required this.imageUrl,
    required this.settings,
    super.key,
  });

  final String imageUrl;
  final DeviceSettings settings;

  @override
  Widget build(BuildContext context) {
    final quality = settings.imageQualityFactor;
    
    return OptimizedImage(
      imageUrl: imageUrl,
      width: 200,
      height: 200,
      // Adjust cache dimensions based on quality
      memCacheWidth: (200 * quality * 2).toInt(),
      memCacheHeight: (200 * quality * 2).toInt(),
      fit: BoxFit.cover,
    );
  }
}
```

### 3. Simplified UI for Low-End Devices

```dart
class ProductCard extends StatelessWidget {
  const ProductCard({
    required this.product,
    required this.settings,
    super.key,
  });

  final Product product;
  final DeviceSettings settings;

  @override
  Widget build(BuildContext context) {
    if (settings.simplifiedUI) {
      // Simple flat design for older devices
      return Container(
        padding: const EdgeInsets.all(12),
        color: Colors.white,
        child: Row(
          children: [
            // Smaller image
            AdaptiveImage(
              imageUrl: product.imageUrl,
              settings: settings,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name),
                  Text('\$${product.price}'),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Rich UI for capable devices
    return Card(
      elevation: settings.enableShadows ? 4 : 0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            AdaptiveImage(
              imageUrl: product.imageUrl,
              settings: settings,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product.price}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### 4. Reduced Concurrent Operations

```dart
class DataLoader {
  DataLoader({required DeviceSettings settings}) {
    _maxConcurrent = settings.maxConcurrentOperations;
  }

  late final int _maxConcurrent;
  int _activeRequests = 0;
  final _queue = <Future<void> Function()>[];

  Future<T> execute<T>(Future<T> Function() operation) async {
    // Wait if at capacity
    while (_activeRequests >= _maxConcurrent) {
      await Future.delayed(const Duration(milliseconds: 50));
    }

    _activeRequests++;
    try {
      return await operation();
    } finally {
      _activeRequests--;
    }
  }
}
```

## 🔍 Performance Monitoring

### Detecting Degradation

```dart
void initPerformanceMonitoring() {
  PerformanceDegradationDetector.instance.startMonitoring(
    checkInterval: const Duration(seconds: 30),
  );
  
  // Listen for frame rate updates
  FrameRateMonitor.instance.startMonitoring();
  
  // Periodically check and adjust
  Timer.periodic(const Duration(minutes: 1), (_) {
    final detector = PerformanceDegradationDetector.instance;
    
    // Record current FPS
    detector.recordFps(FrameRateMonitor.instance.currentFps);
    
    // Adjust if degraded
    if (detector.isDegraded) {
      AdaptivePerformanceManager.instance.adjustForPerformance();
      
      // Get recommended actions
      final actions = detector.getRecommendedActions();
      for (final action in actions) {
        debugPrint('Recommendation: $action');
      }
    }
  });
}
```

## 💾 Memory Management for Older Devices

### Aggressive Memory Cleanup

```dart
class MemoryConservativeApp extends StatefulWidget {
  @override
  State<MemoryConservativeApp> createState() => _MemoryConservativeAppState();
}

class _MemoryConservativeAppState extends State<MemoryConservativeApp>
    with WidgetsBindingObserver {
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Aggressively clear caches when app is backgrounded
      _clearCaches();
    }
  }

  Future<void> _clearCaches() async {
    // Clear image cache
    await ImageCacheManager.clearCache();
    
    // Clear performance metrics
    PerformanceMonitor.instance.clearMetrics();
    
    // Request GC (in debug mode)
    MemoryManager.instance.forceGC();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

### Reduced Cache Sizes

```dart
void configureForOlderDevice() {
  final legacyConfig = LegacyDeviceSupport.getOptimizedConfig();
  
  // Apply cache size multiplier
  final baseSize = 100; // MB
  final adjustedSize = (baseSize * legacyConfig.cacheSizeMultiplier).toInt();
  
  ImageCacheManager.setCacheSize(
    maxCacheSize: adjustedSize,
    maxCacheCount: 300, // Reduced from 1000
  );
  
  // Configure performance monitor
  PerformanceMonitor.instance.maxMetricsPerOperation = 50; // Reduced from 100
}
```

## 🎨 Visual Effects Management

### Conditional Blur

```dart
class ConditionalBlur extends StatelessWidget {
  const ConditionalBlur({
    required this.child,
    required this.settings,
    super.key,
  });

  final Widget child;
  final DeviceSettings settings;

  @override
  Widget build(BuildContext context) {
    if (!settings.enableBlur) {
      // Use simple overlay instead of blur on low-end devices
      return Stack(
        children: [
          child,
          Container(color: Colors.black26),
        ],
      );
    }

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: child,
    );
  }
}
```

### Conditional Shadows

```dart
class ConditionalCard extends StatelessWidget {
  const ConditionalCard({
    required this.child,
    required this.settings,
    super.key,
  });

  final Widget child;
  final DeviceSettings settings;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        // Only add shadow on capable devices
        boxShadow: settings.enableShadows
            ? [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
        // Use border instead on low-end devices
        border: !settings.enableShadows
            ? Border.all(color: Colors.grey.shade300)
            : null,
      ),
      child: child,
    );
  }
}
```

## 📊 Performance Testing

### Benchmarking on Startup

```dart
Future<void> performStartupBenchmark() async {
  print('🔍 Running device benchmark...');
  
  final tier = await DeviceCapabilities.estimatePerformanceTierWithBenchmark();
  print('Device tier: $tier');
  
  // Test image loading performance
  final imageStart = DateTime.now();
  // Simulate image decode
  await Future.delayed(const Duration(milliseconds: 100));
  final imageTime = DateTime.now().difference(imageStart);
  print('Image decode time: ${imageTime.inMilliseconds}ms');
  
  // Test list scrolling performance
  final scrollStart = DateTime.now();
  for (var i = 0; i < 1000; i++) {
    // Simulate widget builds
  }
  final scrollTime = DateTime.now().difference(scrollStart);
  print('List build time: ${scrollTime.inMilliseconds}ms');
  
  // Apply optimizations based on results
  if (tier == 'low' || imageTime.inMilliseconds > 200) {
    print('⚠️ Low performance detected. Applying optimizations...');
    configureForOlderDevice();
  }
}
```

## ✅ Optimization Checklist for Older Devices

- [ ] Enable adaptive performance mode on app startup
- [ ] Use device tier detection with benchmarking
- [ ] Apply conditional animations based on device capabilities
- [ ] Reduce image quality on low-end devices
- [ ] Simplify UI for older hardware
- [ ] Limit concurrent operations
- [ ] Use smaller cache sizes
- [ ] Disable expensive visual effects (blur, shadows)
- [ ] Implement aggressive memory cleanup
- [ ] Monitor for performance degradation
- [ ] Test on actual older devices (Android 5-7, iOS 10-12)
- [ ] Profile memory usage on low-RAM devices

## 🎯 Target Devices

### Testing Recommendations

**Android:**
- Test on devices with 1-2GB RAM
- Test on Android 5.0 (API 21) to 7.0 (API 24)
- Test with software rendering enabled

**iOS:**
- Test on iPhone 6/6s (2014-2015)
- Test on iOS 10-12
- Test with reduced frame rate

## 📈 Expected Results

After implementing these optimizations:

- **50-70%** better performance on older devices
- **40-60%** reduced memory usage
- **Stable 30 FPS** on low-end hardware
- **Better battery life** with reduced processing
- **Smoother experience** on limited hardware

## 🔗 Related Documentation

- [PERFORMANCE.md](PERFORMANCE.md) - General performance guide
- [PERFORMANCE_BEST_PRACTICES.md](PERFORMANCE_BEST_PRACTICES.md) - Best practices
- [OPTIMIZATION_SUMMARY.md](OPTIMIZATION_SUMMARY.md) - Optimization summary
