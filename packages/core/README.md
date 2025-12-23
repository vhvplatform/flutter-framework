# Core Package

The core package provides fundamental functionality for Flutter SaaS applications including authentication, API client, dependency injection, module system, and more.

## Features

- **API Client**: HTTP client with automatic token injection and error handling
- **Authentication Manager**: Complete auth flow with session persistence
- **Dependency Injection**: Service locator pattern with GetIt
- **Module System**: Pluggable modules with dependency resolution
- **Navigation**: Route management
- **Storage**: Secure and local storage wrappers
- **Configuration**: Environment-based app configuration
- **Logger**: Enhanced logging with context and levels
- **Validators**: Comprehensive form validation utilities
- **i18n**: Internationalization support
- **Performance**: Monitoring, debouncing, memory management, image caching, lazy loading
- **Advanced Performance**: Widget optimization, isolates, frame monitoring, startup tracking, network batching, advanced caching

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  core:
    path: ../core
```

## Usage

### API Client

```dart
import 'package:core/api/api_client.dart';

final apiClient = ApiClient(
  baseUrl: 'https://api.example.com',
  authManager: authManager,
);

// GET request
final response = await apiClient.get<User>(
  '/users/me',
  parser: (json) => User.fromJson(json),
);

// POST request
await apiClient.post<User>(
  '/users',
  data: {'name': 'John', 'email': 'john@example.com'},
  parser: (json) => User.fromJson(json),
);
```

### Authentication

```dart
import 'package:core/auth/auth_manager.dart';

// Initialize
final authManager = AuthManager(
  apiClient: apiClient,
  storage: secureStorage,
);
await authManager.init();

// Login
await authManager.login(
  email: 'user@example.com',
  password: 'password',
  tenantId: 'tenant-123',
);

// Check authentication
if (authManager.isAuthenticated) {
  print('User: ${authManager.currentUser?.name}');
}

// Logout
await authManager.logout();
```

### Dependency Injection

```dart
import 'package:core/di/service_locator.dart';

final sl = ServiceLocator.instance;

// Register singleton
sl.registerSingleton<ApiClient>(apiClient);

// Register lazy singleton
sl.registerLazySingleton<AuthService>(() => AuthService());

// Register factory
sl.registerFactory<UserRepository>(() => UserRepository());

// Get instance
final service = sl.get<AuthService>();
```

### Module System

```dart
import 'package:core/modules/module.dart';

// Define a module
class MyModule extends AppModule {
  @override
  String get name => 'my_module';

  @override
  List<String> get dependencies => ['core'];

  @override
  Future<void> initialize() async {
    // Register services
    ServiceLocator.instance.registerLazySingleton<MyService>(
      () => MyService(),
    );
  }

  @override
  Map<String, WidgetBuilder> registerRoutes() {
    return {
      '/my-route': (context) => MyScreen(),
    };
  }
}

// Register and initialize modules
final registry = ModuleRegistry();
await registry.registerAll([MyModule()]);
await registry.initializeAll();
```

### Configuration

```dart
import 'package:core/config/app_config.dart';

final config = AppConfig(
  apiBaseUrl: 'https://api.example.com',
  environment: Environment.production,
  appName: 'My App',
  version: '1.0.0',
);

if (config.isDevelopment) {
  print('Running in development mode');
}
```

## API Response Format

The API client expects responses in this format:

```json
{
  "data": {},
  "message": "Success",
  "metadata": {}
}
```

Error responses:

```json
{
  "message": "Error message",
  "errors": {
    "field": ["error1", "error2"]
  }
}
```

## License

MIT
