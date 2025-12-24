# Flutter SaaS Framework

A complete Flutter framework for building multiple SaaS applications with a modular architecture, multi-tenancy support, and seamless integration with the Go backend (saas-framework-go).

## 🚀 Features

- **Monorepo Architecture**: Manage multiple packages and apps efficiently with Melos
- **Modular Design**: Pluggable feature modules with dependency management
- **Multi-tenancy Support**: Built-in tenant isolation and management
- **Authentication**: Complete auth flow with JWT tokens and refresh logic
- **API Client**: Pre-configured HTTP client with interceptors and error handling
- **UI Kit**: Reusable, customizable Material Design 3 components (45+ widgets)
- **State Management**: Provider-based state management
- **Dependency Injection**: Service locator pattern with GetIt
- **Navigation**: Declarative routing with go_router
- **Secure Storage**: Encrypted storage for sensitive data
- **Type-safe**: Full null safety and strong typing
- **Settings & Profile**: Complete user settings and profile management
- **Form Validators**: Comprehensive validation utilities
- **Enhanced Logger**: Structured logging with context
- **i18n Support**: Built-in internationalization
- **CI/CD**: GitHub Actions workflow for automated testing and building
- **Performance Optimized**: Lazy loading, image caching, debouncing, memory management
- **Advanced Performance**: Widget optimization, isolates, frame monitoring, startup tracking, network batching, advanced caching
- **Developer Experience**: Error boundary, dev menu, hot reload safety, code generator, quick actions

## 📦 Architecture

```
saas-framework-flutter/
├── packages/
│   ├── core/                    # Core framework functionality
│   │   ├── lib/
│   │   │   ├── api/            # HTTP client with interceptors
│   │   │   ├── auth/           # Authentication manager
│   │   │   ├── config/         # App configuration
│   │   │   ├── di/             # Dependency injection
│   │   │   ├── modules/        # Module system
│   │   │   ├── navigation/     # Routing
│   │   │   ├── storage/        # Secure & local storage
│   │   │   ├── utils/          # Logger & validators
│   │   │   └── i18n/           # Internationalization
│   │   └── README.md
│   ├── ui_kit/                  # Shared UI components
│   │   ├── lib/
│   │   │   ├── theme/          # App themes
│   │   │   └── widgets/        # Reusable widgets
│   │   └── README.md
│   └── modules/                 # Feature modules
│       ├── auth_module/        # Authentication screens
│       ├── dashboard_module/   # Dashboard & home
│       ├── user_module/        # User management
│       └── settings_module/    # Settings & profile
├── apps/
│   ├── app1/                   # Example application 1
│   └── app2/                   # Example application 2
├── melos.yaml                  # Monorepo configuration
├── analysis_options.yaml       # Linting rules
└── README.md                   # This file
```

## 🛠️ Prerequisites

- **Flutter SDK**: 3.0.0 or higher
- **Dart SDK**: 3.0.0 or higher
- **Melos**: For monorepo management

### Install Melos

```bash
dart pub global activate melos
```

## 🚦 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/longvhv/saas-framework-flutter.git
cd saas-framework-flutter
```

### 2. Bootstrap the Project

```bash
melos bootstrap
```

This will:
- Install dependencies for all packages
- Link local package dependencies
- Generate necessary files

### 3. Run an Example App

```bash
cd apps/app1
flutter run
```

## 📝 Available Melos Commands

```bash
# Install dependencies for all packages
melos bootstrap

# Analyze all packages
melos analyze

# Format all Dart files
melos format

# Run tests for all packages
melos test

# Clean all packages
melos clean

# Build all apps
melos build

# Get dependencies
melos get

# Generate code (json_serializable, etc.)
melos generate

# Check for outdated dependencies
melos outdated
```

## 🧩 Core Package

The `core` package provides fundamental functionality:

### API Client

```dart
import 'package:core/api/api_client.dart';

final apiClient = ApiClient(
  baseUrl: 'https://api.example.com',
  authManager: authManager,
);

// Make API calls
final response = await apiClient.get<User>(
  '/users/me',
  parser: (json) => User.fromJson(json),
);
```

### Authentication

```dart
import 'package:core/auth/auth_manager.dart';

final authManager = AuthManager(
  apiClient: apiClient,
  storage: secureStorage,
);

// Login
await authManager.login(
  email: 'user@example.com',
  password: 'password',
  tenantId: 'tenant-123',
);

// Check auth state
if (authManager.isAuthenticated) {
  final user = authManager.currentUser;
}

// Logout
await authManager.logout();
```

### Dependency Injection

```dart
import 'package:core/di/service_locator.dart';

// Register services
ServiceLocator.instance.registerSingleton<ApiClient>(apiClient);
ServiceLocator.instance.registerLazySingleton<AuthService>(
  () => AuthService(),
);

// Retrieve services
final service = ServiceLocator.instance.get<AuthService>();
```

### Module System

```dart
import 'package:core/modules/module.dart';

class MyModule extends AppModule {
  @override
  String get name => 'my_module';

  @override
  List<String> get dependencies => ['core'];

  @override
  Future<void> initialize() async {
    // Register services, routes, etc.
  }
}

// Register and initialize modules
final registry = ModuleRegistry();
await registry.registerAll([
  AuthModule(),
  DashboardModule(),
  MyModule(),
]);
await registry.initializeAll();
```

## 🎨 UI Kit Package

Reusable UI components with Material Design 3:

```dart
import 'package:ui_kit/widgets/app_button.dart';
import 'package:ui_kit/widgets/app_text_field.dart';
import 'package:ui_kit/theme/app_theme.dart';

// Use themed components
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  home: Scaffold(
    body: Column(
      children: [
        AppTextField(
          label: 'Email',
          validator: (value) => value?.isEmpty ?? true
            ? 'Required'
            : null,
        ),
        AppButton(
          text: 'Submit',
          onPressed: () {},
          variant: ButtonVariant.primary,
        ),
      ],
    ),
  ),
);
```

## 🔌 Creating a New Module

### 1. Create Module Structure

```bash
mkdir -p packages/modules/my_module/lib
cd packages/modules/my_module
```

### 2. Create pubspec.yaml

```yaml
name: my_module
version: 1.0.0
publish_to: none

environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: ">=3.0.0"

dependencies:
  flutter:
    sdk: flutter
  core:
    path: ../../core
  ui_kit:
    path: ../../ui_kit
```

### 3. Implement Module Class

```dart
// lib/my_module.dart
import 'package:core/modules/module.dart';
import 'package:core/di/service_locator.dart';

class MyModule extends AppModule {
  @override
  String get name => 'my_module';

  @override
  String get version => '1.0.0';

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

  @override
  void dispose() {
    // Cleanup
  }
}
```

## 🏗️ Creating a New App

### 1. Create App Directory

```bash
mkdir -p apps/my_app
cd apps/my_app
```

### 2. Initialize Flutter App

```bash
flutter create . --org com.example --project-name my_app
```

### 3. Update pubspec.yaml

```yaml
name: my_app
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  core:
    path: ../../packages/core
  ui_kit:
    path: ../../packages/ui_kit
  auth_module:
    path: ../../packages/modules/auth_module
  dashboard_module:
    path: ../../packages/modules/dashboard_module
```

### 4. Configure main.dart

```dart
import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:auth_module/auth_module.dart';
import 'package:dashboard_module/dashboard_module.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load configuration
  final config = AppConfig(
    apiBaseUrl: 'https://api.example.com',
    environment: Environment.production,
    appName: 'My App',
    version: '1.0.0',
  );

  // Initialize DI
  final sl = ServiceLocator.instance;
  
  // Register core services
  sl.registerSingleton<AppConfig>(config);
  sl.registerLazySingleton<SecureStorage>(() => SecureStorage());
  sl.registerLazySingleton<LocalStorage>(() => LocalStorage());
  
  final apiClient = ApiClient(
    baseUrl: config.apiBaseUrl,
    authManager: null, // Set after auth manager creation
  );
  sl.registerSingleton<ApiClient>(apiClient);
  
  final authManager = AuthManager(
    apiClient: apiClient,
    storage: sl.get<SecureStorage>(),
  );
  sl.registerSingleton<AuthManager>(authManager);
  
  // Initialize auth manager
  await authManager.init();

  // Register and initialize modules
  final registry = ModuleRegistry();
  await registry.registerAll([
    AuthModule(),
    DashboardModule(),
  ]);
  await registry.initializeAll();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: LoginScreen(),
    );
  }
}
```

## 🔄 Integration with Go Backend

The framework is designed to integrate seamlessly with the saas-framework-go backend:

### API Response Format

```json
{
  "data": {},
  "message": "Success",
  "metadata": {}
}
```

### Error Format

```json
{
  "message": "Error message",
  "errors": {
    "field": ["error1", "error2"]
  }
}
```

### Headers

- **Authorization**: `Bearer <token>`
- **X-Tenant-ID**: `<tenant-id>`

## 🧪 Testing

### Run All Tests

```bash
melos test
```

### Run Tests for Specific Package

```bash
cd packages/core
flutter test
```

## 📱 Building

### Build for Android

```bash
cd apps/app1
flutter build apk
```

### Build for iOS

```bash
cd apps/app1
flutter build ios
```

### Build for Web

```bash
cd apps/app1
flutter build web
```

## 🎯 Best Practices

1. **Keep Widgets Small**: Break down complex widgets into smaller, focused components
2. **Separate Business Logic**: Use services and repositories, not widgets
3. **Use Const Constructors**: Improve performance with `const` where possible
4. **Dispose Controllers**: Always dispose of controllers and subscriptions
5. **Handle Errors**: Implement proper error handling and user feedback
6. **Type Safety**: Leverage Dart's type system and null safety
7. **Code Documentation**: Add comments for complex logic
8. **Follow Conventions**: Adhere to Flutter and Dart naming conventions

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License.

## 📚 Documentation

- **[SETUP.md](SETUP.md)** - Complete setup and installation guide
- **[UI_KIT_GUIDE.md](UI_KIT_GUIDE.md)** - Complete UI components guide with 25+ widgets and examples
- **[DEV_GUIDE.md](DEV_GUIDE.md)** - Developer guide for easier development
- **[FEATURES.md](FEATURES.md)** - New features and enhancements documentation
- **[PERFORMANCE.md](PERFORMANCE.md)** - Performance optimizations guide
- **[ADVANCED_PERFORMANCE.md](ADVANCED_PERFORMANCE.md)** - Advanced performance techniques
- **[IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md)** - Detailed implementation summary
- **[Core Package README](packages/core/README.md)** - Core package documentation
- **[UI Kit Package README](packages/ui_kit/README.md)** - UI Kit package overview

## 🆘 Support

For questions and support, please open an issue on GitHub.

## 🔗 Related Projects

- [saas-framework-go](https://github.com/longvhv/saas-framework-go) - Go backend framework

---

Built with ❤️ for the Flutter community
