# Performance Best Practices for Flutter SaaS Framework

This document provides comprehensive best practices for optimizing performance in the Flutter SaaS Framework.

## 🎯 Core Principles

### 1. Minimize Widget Rebuilds

**Bad:**
```dart
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Counter: $counter'), // Only this needs to rebuild
        ExpensiveWidget(), // This rebuilds unnecessarily
      ],
    );
  }
}
```

**Good:**
```dart
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Counter: $counter'),
        const ExpensiveWidget(), // const prevents rebuild
      ],
    );
  }
}
```

### 2. Use const Constructors Everywhere

**Impact:** Reduces widget creation overhead by 30-50%

```dart
// Bad
return Container(
  padding: EdgeInsets.all(16),
  child: Text('Hello'),
);

// Good
return Container(
  padding: const EdgeInsets.all(16),
  child: const Text('Hello'),
);
```

### 3. Implement Proper Disposal

**Memory Leak Prevention:**

```dart
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late TextEditingController _controller;
  late ScrollController _scrollController;
  late StreamSubscription _subscription;
  late Debouncer _debouncer;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _scrollController = ScrollController();
    _debouncer = Debouncer(duration: const Duration(milliseconds: 300));
    
    _subscription = someStream.listen((data) {
      // Handle data
    });
  }

  @override
  void dispose() {
    // Dispose in reverse order of creation
    _debouncer.dispose();
    _subscription.cancel();
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(controller: _controller);
  }
}
```

## 🚀 List Performance

### Use Lazy Loading for Long Lists

```dart
class UserList extends StatelessWidget {
  final List<User> users;
  final VoidCallback onLoadMore;
  final bool hasMore;
  final bool isLoading;

  const UserList({
    required this.users,
    required this.onLoadMore,
    required this.hasMore,
    required this.isLoading,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LazyListView<User>(
      items: users,
      itemBuilder: (context, user, index) {
        return UserCard(
          key: ValueKey(user.id), // Important!
          user: user,
        );
      },
      onLoadMore: onLoadMore,
      hasMore: hasMore,
      isLoading: isLoading,
      loadMoreThreshold: 3,
    );
  }
}
```

### Optimize List Items

```dart
class UserCard extends StatelessWidget {
  final User user;

  const UserCard({
    required this.user,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Use RepaintBoundary for complex items
    return RepaintBoundary(
      child: Card(
        child: ListTile(
          leading: OptimizedImage(
            imageUrl: user.avatar,
            width: 50,
            height: 50,
          ),
          title: Text(user.name),
          subtitle: Text(user.email),
        ),
      ),
    );
  }
}
```

## 🖼️ Image Optimization

### Always Use OptimizedImage

```dart
// Bad
Image.network('https://example.com/image.jpg')

// Good
OptimizedImage(
  imageUrl: 'https://example.com/image.jpg',
  width: 200,
  height: 200,
  fit: BoxFit.cover,
  placeholder: const CircularProgressIndicator(),
  errorWidget: const Icon(Icons.error),
)
```

### Configure Cache Properly

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configure image cache
  ImageCacheManager.setCacheSize(
    maxCacheSize: 100, // 100 MB
    maxCacheCount: 1000,
  );
  
  runApp(MyApp());
}
```

## ⚡ Async Operations

### Use Performance Monitoring

```dart
Future<List<User>> fetchUsers() async {
  return await PerformanceMonitor.instance.measure(
    'fetch_users',
    () async {
      final response = await apiClient.get('/users');
      return parseUsers(response);
    },
  );
}
```

### Debounce User Input

```dart
class SearchWidget extends StatefulWidget {
  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final _debouncer = Debouncer(
    duration: const Duration(milliseconds: 300),
  );

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (query) {
        _debouncer.run(() {
          performSearch(query);
        });
      },
    );
  }
}
```

### Throttle Scroll Events

```dart
class ScrollableWidget extends StatefulWidget {
  @override
  State<ScrollableWidget> createState() => _ScrollableWidgetState();
}

class _ScrollableWidgetState extends State<ScrollableWidget> {
  final _throttler = Throttler(
    duration: const Duration(milliseconds: 100),
  );

  @override
  void dispose() {
    _throttler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        _throttler.run(() {
          handleScroll(notification);
        });
        return true;
      },
      child: ListView(...),
    );
  }
}
```

## 🧮 Heavy Computations

### Use Isolates for CPU-Intensive Work

```dart
// Define top-level or static function
static List<ProcessedItem> processData(List<RawItem> items) {
  return items.map((item) => ProcessedItem(item)).toList();
}

// Use in widget
Future<void> processLargeDataset() async {
  final processed = await IsolateHelper.compute(
    processData,
    rawItems,
    debugLabel: 'ProcessData',
  );
  
  setState(() {
    processedItems = processed;
  });
}
```

### Use Isolate Pool for Frequent Operations

```dart
class DataService {
  late IsolatePool<RawData, ProcessedData> _pool;

  void initialize() {
    _pool = IsolatePool<RawData, ProcessedData>(
      callback: _processData,
      poolSize: 4,
    );
  }

  Future<ProcessedData> process(RawData data) {
    return _pool.run(data);
  }

  static ProcessedData _processData(RawData data) {
    // Heavy processing here
    return ProcessedData(data);
  }

  void dispose() {
    _pool.dispose();
  }
}
```

## 📊 Performance Monitoring

### Track App Startup

```dart
void main() async {
  StartupTracker.instance.markAppStart();
  
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load config
  final config = await loadConfig();
  StartupTracker.instance.markMilestone(StartupMilestones.configLoaded);
  
  // Initialize DI
  await setupDI(config);
  StartupTracker.instance.markMilestone(StartupMilestones.diInitialized);
  
  runApp(MyApp());
  
  WidgetsBinding.instance.addPostFrameCallback((_) {
    StartupTracker.instance.markMilestone(
      StartupMilestones.firstFrameRendered,
    );
    StartupTracker.instance.printReport();
  });
}
```

### Monitor Frame Rate (Debug Only)

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (kDebugMode) {
    FrameRateMonitor.instance.startMonitoring(
      reportInterval: const Duration(seconds: 10),
    );
  }
  
  runApp(MyApp());
}
```

## 🎨 Widget Optimization Patterns

### Use ValueListenableSelector for Granular Updates

```dart
class UserProfile extends StatelessWidget {
  final ValueNotifier<User> userNotifier;

  const UserProfile({
    required this.userNotifier,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Only rebuilds when name changes
        ValueListenableSelector<User, String>(
          valueListenable: userNotifier,
          selector: (user) => user.name,
          builder: (context, name, child) {
            return Text(name);
          },
        ),
        // Only rebuilds when email changes
        ValueListenableSelector<User, String>(
          valueListenable: userNotifier,
          selector: (user) => user.email,
          builder: (context, email, child) {
            return Text(email);
          },
        ),
      ],
    );
  }
}
```

### Use CachedWidget for Expensive Items

```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return CachedWidget(
      cacheKey: items[index].id,
      child: ExpensiveItem(item: items[index]),
    );
  },
)
```

## 💾 Memory Management

### Track Objects for Memory Leaks (Debug)

```dart
void initState() {
  super.initState();
  _controller = TextEditingController();
  
  if (kDebugMode) {
    MemoryManager.instance.trackObject(
      _controller,
      'SearchController',
    );
  }
}
```

### Start GC Monitoring (Debug)

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (kDebugMode) {
    MemoryManager.instance.startGCMonitoring(
      interval: const Duration(minutes: 1),
    );
  }
  
  runApp(MyApp());
}
```

## 🌐 Network Optimization

### Use Request Deduplication

```dart
class UserRepository {
  final _deduplicator = RequestDeduplicator();

  Future<User> getUser(String id) {
    return _deduplicator.execute(
      key: 'user_$id',
      request: () => apiClient.get('/users/$id'),
    );
  }
}
```

### Implement Response Caching

```dart
class CachedApiClient {
  final _cache = RefreshableCache<String, dynamic>(
    fetcher: (key) => _fetchFromNetwork(key),
    maxSize: 100,
    ttl: const Duration(minutes: 5),
    refreshThreshold: const Duration(minutes: 4),
  );

  Future<T> get<T>(
    String path,
    T Function(dynamic) parser,
  ) async {
    final data = await _cache.get(path);
    return parser(data);
  }

  Future<dynamic> _fetchFromNetwork(String path) async {
    final response = await dio.get(path);
    return response.data;
  }
}
```

## ✅ Performance Checklist

Before deploying to production:

### Startup Performance
- [ ] Startup time < 2 seconds on target devices
- [ ] All heavy initialization deferred or parallelized
- [ ] Splash screen shows immediately

### Runtime Performance
- [ ] Frame rate consistently > 55 FPS
- [ ] Jank percentage < 5%
- [ ] No frame drops during scrolling

### Memory Management
- [ ] All controllers properly disposed
- [ ] All subscriptions canceled
- [ ] No memory leaks detected
- [ ] Image cache configured appropriately

### Code Quality
- [ ] const constructors used where possible
- [ ] Widget keys used for list items
- [ ] RepaintBoundary used for complex widgets
- [ ] Debouncing/throttling implemented for user input

### Network
- [ ] Request deduplication implemented
- [ ] Response caching configured
- [ ] Proper error handling in place

### Images
- [ ] All images use OptimizedImage or have cache settings
- [ ] Image sizes optimized for display
- [ ] Placeholder and error widgets provided

## 🔧 Profiling Tools

### Flutter DevTools

```bash
# Run in profile mode
flutter run --profile

# Open DevTools
flutter pub global activate devtools
flutter pub global run devtools
```

### Performance Overlay

```dart
MaterialApp(
  debugShowCheckedModeBanner: false,
  showPerformanceOverlay: true, // Shows FPS
  home: HomeScreen(),
)
```

### Memory Info Overlay

```dart
MaterialApp(
  debugShowCheckedModeBanner: false,
  showSemanticsDebugger: false,
  checkerboardOffscreenLayers: true, // Debug rendering
  checkerboardRasterCacheImages: true, // Debug caching
  home: HomeScreen(),
)
```

## 📈 Expected Results

After implementing these optimizations:

- **30-50%** faster list scrolling
- **20-40%** reduced memory usage
- **50-70%** faster image loading
- **40-60%** fewer network requests
- **Consistent 60 FPS** on target devices
- **< 2 second** app startup time

## 📚 Additional Resources

- [Flutter Performance Best Practices](https://flutter.dev/docs/perf/best-practices)
- [Flutter Performance Profiling](https://flutter.dev/docs/perf/rendering)
- [Dart VM Performance](https://dart.dev/guides/language/performance)
