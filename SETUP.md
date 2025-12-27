# Setup Guide

This guide will help you set up and run the Flutter SaaS Framework.

## 🚀 Quick Start (Recommended)

**For the fastest setup experience**, use our automated setup script:

```bash
# 1. Clone the repository
git clone https://github.com/vhvplatform/flutter-framework.git
cd flutter-framework

# 2. Verify prerequisites (optional but recommended)
./verify-prerequisites.sh

# 3. Run automated setup
./setup.sh

# 4. Run an example app
cd apps/app1
flutter run
```

**OR** use Makefile shortcuts (requires make):

```bash
# 1. Clone the repository
git clone https://github.com/vhvplatform/flutter-framework.git
cd flutter-framework

# 2. Run setup
make setup

# 3. Run an example app
make run-app1
```

The automated setup script will:
- ✓ Check all prerequisites (Flutter, Dart, Git, Melos)
- ✓ Install missing tools (like Melos)
- ✓ Bootstrap all packages
- ✓ Run code generation if needed
- ✓ Verify the installation

---

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** 3.0.0 or higher
- **Dart SDK** 3.0.0 or higher
- **Git** for version control
- **Melos** for monorepo management (will be auto-installed by setup script)

### Install Flutter

1. Download Flutter SDK from [flutter.dev](https://flutter.dev/docs/get-started/install)
2. Add Flutter to your PATH
3. Run `flutter doctor` to verify installation

### Install Melos (Optional - Auto-installed)

```bash
dart pub global activate melos
```

Make sure the pub cache bin directory is in your PATH:

```bash
export PATH="$PATH:$HOME/.pub-cache/bin"
```

Add this to your shell profile (~/.bashrc, ~/.zshrc, etc.) to make it permanent.

---

## 🔧 Manual Setup

If you prefer to set up manually without using the automated script:

### 1. Clone the Repository

```bash
git clone https://github.com/vhvplatform/flutter-framework.git
cd flutter-framework
```

### 2. Bootstrap the Project

Run Melos bootstrap to install dependencies for all packages:

```bash
melos bootstrap
```

This command will:
- Install dependencies for all packages in parallel
- Link local package dependencies
- Generate necessary files

### 3. Generate Code (Optional)

Generate JSON serialization code if packages use build_runner:

```bash
melos generate
```

### 4. Verify Setup

Run analysis to check for any issues:

```bash
melos analyze
```

### 5. Run Tests (Optional)

```bash
melos test
```

### 6. Run an Example App

Navigate to an app directory and run:

```bash
cd apps/app1
flutter run
```

Or use device selection:

```bash
flutter run -d chrome    # For web
flutter run -d macos     # For macOS
flutter run              # For connected device
```

## Project Structure

```
flutter-framework/
├── packages/
│   ├── core/                    # Core framework
│   ├── ui_kit/                  # UI components
│   └── modules/                 # Feature modules
│       ├── auth_module/
│       ├── dashboard_module/
│       └── user_module/
├── apps/
│   ├── app1/                    # Example app 1
│   └── app2/                    # Example app 2
├── melos.yaml                   # Monorepo config
└── README.md
```

## Development Workflow

### Adding Dependencies

To add a dependency to a specific package:

```bash
cd packages/core
flutter pub add package_name
```

Then run `melos bootstrap` to update all packages.

### Creating a New Module

1. Create module directory:
```bash
mkdir -p packages/modules/my_module/lib
cd packages/modules/my_module
```

2. Create `pubspec.yaml`:
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

3. Create module class in `lib/my_module.dart`:
```dart
import 'package:core/core.dart';

class MyModule extends AppModule {
  @override
  String get name => 'my_module';

  @override
  Future<void> initialize() async {
    // Register services
  }

  @override
  Map<String, WidgetBuilder> registerRoutes() {
    return {
      '/my-route': (context) => MyScreen(),
    };
  }
}
```

4. Run bootstrap:
```bash
cd ../../..
melos bootstrap
```

### Creating a New App

1. Create app directory:
```bash
cd apps
flutter create my_app --org com.example
cd my_app
```

2. Update `pubspec.yaml` to include local packages:
```yaml
dependencies:
  flutter:
    sdk: flutter
  core:
    path: ../../packages/core
  ui_kit:
    path: ../../packages/ui_kit
  auth_module:
    path: ../../packages/modules/auth_module
```

3. Update `lib/main.dart` with initialization code (see app1 for example)

4. Run bootstrap:
```bash
cd ../..
melos bootstrap
```

## Common Commands

### Using Makefile (Recommended)

For convenience, use the provided Makefile shortcuts:

```bash
# Show all available commands
make help

# Setup and installation
make setup          # Run automated setup (first time)
make bootstrap      # Install dependencies
make install        # Alias for bootstrap

# Development
make run-app1       # Run app1
make run-app2       # Run app2
make analyze        # Run code analysis
make format         # Format code
make test           # Run tests
make generate       # Run code generation

# Maintenance
make clean          # Clean all packages
make get            # Get dependencies
make upgrade        # Upgrade dependencies
make outdated       # Check for outdated packages

# Diagnostics
make doctor         # Run flutter doctor
```

### Using Melos Directly

```bash
# Install dependencies
melos bootstrap

# Run analysis
melos analyze

# Format code
melos format

# Run tests
melos test

# Clean all packages
melos clean

# Build apps
melos build

# Check for outdated packages
melos outdated
```

## Troubleshooting

### Issue: "flutter: command not found"

**Solution**: Install Flutter SDK and add it to your PATH.

### Issue: "melos: command not found"

**Solution**: 
```bash
dart pub global activate melos
# Add to PATH: export PATH="$PATH":"$HOME/.pub-cache/bin"
```

### Issue: "Could not resolve package"

**Solution**: Run `melos clean` then `melos bootstrap`

### Issue: "Build errors after adding new package"

**Solution**: 
1. Run `flutter clean` in the specific package
2. Run `melos bootstrap`
3. If using code generation, run `melos generate`

### Issue: "Analysis errors"

**Solution**: Check `analysis_options.yaml` and fix linting issues:
```bash
melos analyze
```

## IDE Setup

### VS Code

Install extensions:
- Flutter
- Dart
- Flutter Intl (for i18n)

Add to `.vscode/settings.json`:
```json
{
  "dart.flutterSdkPath": "/path/to/flutter",
  "editor.formatOnSave": true,
  "dart.lineLength": 80
}
```

### Android Studio / IntelliJ

1. Install Flutter and Dart plugins
2. Set Flutter SDK path in Preferences
3. Enable "Format on Save"

## Backend Integration

The framework is designed to work with the saas-framework-go backend.

### API Configuration

Update the API base URL in your app's `main.dart`:

```dart
final config = AppConfig(
  apiBaseUrl: 'https://your-api.example.com',
  environment: Environment.production,
  appName: 'Your App',
  version: '1.0.0',
);
```

### Expected API Format

#### Success Response
```json
{
  "data": {},
  "message": "Success",
  "metadata": {}
}
```

#### Error Response
```json
{
  "message": "Error message",
  "errors": {
    "field": ["error1", "error2"]
  }
}
```

### Required Endpoints

- `POST /auth/login` - User login
- `POST /auth/register` - User registration
- `POST /auth/refresh` - Token refresh
- `GET /auth/me` - Get current user
- `POST /auth/logout` - Logout
- `GET /users` - List users
- `GET /users/:id` - Get user by ID
- `PUT /users/:id` - Update user
- `DELETE /users/:id` - Delete user

## Deployment

### Android

```bash
cd apps/app1
flutter build apk --release
# APK location: build/app/outputs/flutter-apk/app-release.apk
```

### iOS

```bash
cd apps/app1
flutter build ios --release
# Open ios/Runner.xcworkspace in Xcode to archive
```

### Web

```bash
cd apps/app1
flutter build web --release
# Output: build/web/
```

## Best Practices

1. **Always run bootstrap after adding dependencies**
2. **Use const constructors where possible**
3. **Follow the linting rules in analysis_options.yaml**
4. **Dispose controllers and subscriptions**
5. **Write tests for business logic**
6. **Use the module system for organization**
7. **Keep widgets small and focused**
8. **Document public APIs**

## Support

For issues and questions:
- Create an issue on GitHub
- Check existing documentation
- Review example apps for usage patterns

## License

MIT License - See LICENSE file for details
