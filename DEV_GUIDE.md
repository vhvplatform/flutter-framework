# Developer Guide

This guide helps you develop faster and more efficiently with the SaaS Framework.

## Table of Contents

1. [Quick Start](#quick-start)
2. [Developer Tools](#developer-tools)
3. [Code Generation](#code-generation)
4. [Hot Reload Best Practices](#hot-reload-best-practices)
5. [Debugging](#debugging)
6. [Common Workflows](#common-workflows)

---

## Quick Start

### Initial Setup

```bash
# Install Melos
dart pub global activate melos

# Bootstrap the project
melos bootstrap

# Run example app
cd apps/app1
flutter run
```

### Development Mode

The framework automatically enables developer tools in development environment:

```dart
final config = AppConfig(
  apiBaseUrl: 'http://localhost:8080',
  environment: Environment.development, // Enables dev tools
  appName: 'My SaaS App',
  version: '1.0.0',
);
```

---

## Developer Tools

### Dev Menu

Access the developer menu by tapping the floating purple button (bottom right) in development mode.

**Features:**
- **Info Tab**: App configuration and environment details
- **Performance Tab**: Real-time FPS, jank metrics, and performance reports
- **Logs Tab**: Quick access to logging functions
- **Network Tab**: Network monitoring (coming soon)

**Usage:**

```dart
void main() {
  runApp(
    DevMenu(
      config: config,
      child: MyApp(),
    ),
  );
}
```

### Error Boundary

Catch and display errors gracefully during development:

```dart
// Wrap your app
ErrorBoundary(
  child: MyApp(),
  onError: (details) {
    // Custom error handling
    AppLogger.instance.error('App error', error: details.exception);
  },
)

// Or use extension
MyApp().withErrorBoundary()
```

### Hot Reload Safety

Make your classes hot-reload safe:

```dart
class MyService with HotReloadSafe {
  @override
  void onReassemble() {
    super.onReassemble();
    // Re-initialize if needed
  }
}

// In StatefulWidget
class _MyScreenState extends State<MyScreen> {
  @override
  void reassemble() {
    super.reassemble();
    handleReassemble(); // From HotReloadAwareState extension
  }

  @override
  void onHotReload() {
    // Your hot reload logic
    print('Screen hot reloaded');
  }
}
```

### Persist State Across Hot Reloads

```dart
void initState() {
  super.initState();
  
  // Check if state exists from previous hot reload
  if (HotReloadPersistence.has('my_data')) {
    _data = HotReloadPersistence.get('my_data');
  } else {
    _data = loadData();
  }
}

void dispose() {
  // Save state for next hot reload
  HotReloadPersistence.save('my_data', _data);
  super.dispose();
}
```

### Quick Actions

Register shortcuts for common development tasks:

```dart
void main() {
  // Register quick actions
  QuickActions.register(
    QuickAction(
      label: 'Clear Cache',
      icon: Icons.delete,
      onTap: () => clearCache(),
      color: Colors.red,
    ),
  );
  
  QuickActions.register(
    QuickAction(
      label: 'Reload Data',
      icon: Icons.refresh,
      onTap: () => reloadData(),
      color: Colors.blue,
    ),
  );
  
  runApp(MyApp());
}

// Show quick actions
FloatingActionButton(
  onPressed: () => QuickActions.show(context),
  child: Icon(Icons.bolt),
)
```

---

## Code Generation

Use built-in code generators to create boilerplate quickly:

### Generate a New Module

```dart
// Print to console or save to file
final code = CodeGenerator.generateModule('notifications');
print(code);

// Creates:
// - NotificationsModule class
// - Module initialization
// - Route registration template
```

### Generate a Screen

```dart
final code = CodeGenerator.generateScreen('notifications_list');
// Creates complete StatefulWidget with scaffold
```

### Generate a Repository

```dart
final code = CodeGenerator.generateRepository('notification');
// Creates repository with CRUD methods
```

### Generate a Service

```dart
final code = CodeGenerator.generateService('notification');
// Creates service with repository dependency
```

### Generate a Model

```dart
final code = CodeGenerator.generateModel('notification', {
  'id': 'String',
  'title': 'String',
  'message': 'String',
  'isRead': 'bool',
  'createdAt': 'DateTime',
});
// Creates model with JSON serialization
```

### CLI Helper Script

Create `scripts/generate.dart`:

```dart
import 'dart:io';
import 'package:core/dev_tools/code_generator.dart';

void main(List<String> args) {
  if (args.length < 2) {
    print('Usage: dart scripts/generate.dart <type> <name>');
    print('Types: module, screen, repository, service, model');
    exit(1);
  }

  final type = args[0];
  final name = args[1];
  String code;

  switch (type) {
    case 'module':
      code = CodeGenerator.generateModule(name);
      break;
    case 'screen':
      code = CodeGenerator.generateScreen(name);
      break;
    case 'repository':
      code = CodeGenerator.generateRepository(name);
      break;
    case 'service':
      code = CodeGenerator.generateService(name);
      break;
    default:
      print('Unknown type: $type');
      exit(1);
  }

  print(code);
}
```

Run: `dart scripts/generate.dart module notifications`

---

## Hot Reload Best Practices

### DO

✅ Use `const` constructors wherever possible
```dart
const Text('Hello') // ✅ Fast hot reload
```

✅ Keep state in StatefulWidgets
```dart
class _MyState extends State<MyWidget> {
  int _counter = 0; // ✅ State preserved
}
```

✅ Use ValueNotifier for simple state
```dart
final counter = ValueNotifier(0); // ✅ Survives hot reload
```

### DON'T

❌ Store state in top-level variables
```dart
int counter = 0; // ❌ Reset on hot reload
```

❌ Initialize in static fields
```dart
static final myService = MyService(); // ❌ May not update
```

❌ Forget to dispose controllers
```dart
// ❌ Memory leak
TextEditingController controller;

// ✅ Proper disposal
@override
void dispose() {
  controller.dispose();
  super.dispose();
}
```

---

## Debugging

### Enable Verbose Logging

```dart
AppLogger.instance.init(level: Level.debug);
```

### Performance Debugging

```dart
// Start frame monitoring
FrameRateMonitor.instance.startMonitoring();

// Measure operations
final result = await PerformanceMonitor.instance.measure(
  'load_users',
  () => loadUsers(),
);

// Print reports
PerformanceMonitor.instance.printReport();
MemoryManager.instance.printTrackedObjects();
```

### Track Widget Builds

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('MyWidget built'); // Track rebuilds
    return Container();
  }
}
```

### Use Flutter DevTools

```bash
# Open DevTools
flutter pub global activate devtools
flutter pub global run devtools
```

---

## Common Workflows

### Creating a New Feature Module

1. Generate module structure:
```dart
final code = CodeGenerator.generateModule('feature_name');
```

2. Create directory structure:
```
packages/modules/feature_name_module/
├── lib/
│   ├── feature_name_module.dart
│   ├── screens/
│   ├── services/
│   └── repository/
└── pubspec.yaml
```

3. Register module in app:
```dart
await registry.registerAll([
  FeatureNameModule(),
]);
```

### Adding a New Screen

1. Generate screen:
```dart
final code = CodeGenerator.generateScreen('my_screen');
```

2. Add route in module:
```dart
@override
List<AppRoute> registerRoutes() {
  return [
    AppRoute(
      path: '/my-screen',
      name: 'my_screen',
      builder: (context) => MyScreen(),
    ),
  ];
}
```

3. Navigate:
```dart
Navigator.of(context).pushNamed('/my-screen');
```

### Implementing API Integration

1. Generate repository:
```dart
final code = CodeGenerator.generateRepository('entity');
```

2. Register in DI:
```dart
sl.registerLazySingleton<EntityRepository>(
  () => EntityRepository(),
);
```

3. Use in service:
```dart
class EntityService {
  final EntityRepository _repository;
  
  EntityService() : _repository = ServiceLocator.instance.get();
  
  Future<List<Entity>> getAll() => _repository.getAll();
}
```

### Testing Performance Changes

1. Baseline measurement:
```dart
StartupTracker.instance.markAppStart();
// ... initialization
StartupTracker.instance.printReport();
```

2. Make changes

3. Compare results:
```bash
# Before: Startup time: 2.5s
# After: Startup time: 1.8s (28% improvement)
```

---

## Tips & Tricks

### Quick Restart App

```dart
// Add to your app
void restartApp() {
  runApp(MyApp());
}

// Use in dev menu or quick action
QuickActions.register(
  QuickAction(
    label: 'Restart App',
    icon: Icons.restart_alt,
    onTap: restartApp,
  ),
);
```

### Mock API for Development

```dart
if (config.environment == Environment.development) {
  // Use mock API client
  sl.registerSingleton<ApiClient>(
    MockApiClient(),
  );
} else {
  sl.registerSingleton<ApiClient>(
    ApiClient(baseUrl: config.apiBaseUrl),
  );
}
```

### Feature Flags

```dart
class FeatureFlags {
  static bool get newDashboard => 
    AppConfig.instance.environment == Environment.development;
    
  static bool get experimentalFeature => false;
}

// Use in code
if (FeatureFlags.newDashboard) {
  return NewDashboardScreen();
}
```

### Environment-Specific Config

```dart
// config/dev.dart
final devConfig = AppConfig(
  apiBaseUrl: 'http://localhost:8080',
  environment: Environment.development,
  appName: 'My App (Dev)',
  version: '1.0.0-dev',
);

// config/prod.dart
final prodConfig = AppConfig(
  apiBaseUrl: 'https://api.production.com',
  environment: Environment.production,
  appName: 'My App',
  version: '1.0.0',
);

// main.dart
void main() {
  final config = kDebugMode ? devConfig : prodConfig;
  runApp(MyApp(config: config));
}
```

---

## Keyboard Shortcuts

When using VS Code with Flutter:

- `Ctrl/Cmd + S` - Save and Hot Reload
- `Ctrl/Cmd + Shift + F5` - Hot Restart
- `Ctrl/Cmd + F5` - Run without debugging
- `Shift + F5` - Stop debugging

---

## Getting Help

- Check logs in dev menu
- Use error boundary to catch crashes
- Print performance reports
- Check memory usage
- Use Flutter DevTools
- Review ADVANCED_PERFORMANCE.md for optimization tips

---

## Next Steps

1. Read [FEATURES.md](FEATURES.md) for all framework features
2. Check [PERFORMANCE.md](PERFORMANCE.md) for optimization guide
3. See [ADVANCED_PERFORMANCE.md](ADVANCED_PERFORMANCE.md) for advanced patterns
4. Review example apps in `apps/` directory
