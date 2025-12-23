# Additional Features

This document describes the additional features added to the Flutter SaaS Framework.

## 🎯 New Features Overview

### 1. **Settings Module** 📱
Complete settings and profile management system.

#### Features:
- **Profile Screen**: Edit user profile, upload profile picture
- **Settings Screen**: 
  - Account settings (profile, change password)
  - Preferences (notifications, dark mode, language)
  - About section (version, terms, privacy policy)
  - Logout with confirmation

#### Usage:
```dart
// Register the module
await registry.registerAll([
  SettingsModule(),
]);

// Navigate to settings
Navigator.of(context).pushNamed('/settings');

// Navigate to profile
Navigator.of(context).pushNamed('/profile');
```

### 2. **Enhanced Logger** 🔍
Structured logging with different log levels and context.

#### Features:
- Multiple log levels: debug, info, warning, error, fatal
- Contextual logging with metadata
- Pretty printing with colors and emojis
- Stack trace support for errors
- Configurable log levels

#### Usage:
```dart
import 'package:core/core.dart';

// Initialize logger (optional, auto-initializes on first use)
AppLogger.instance.init(
  level: Level.debug,
  enableInRelease: false,
);

// Log messages
AppLogger.instance.debug('Debug message');
AppLogger.instance.info('Info message');
AppLogger.instance.warning('Warning message');
AppLogger.instance.error('Error occurred', error: e, stackTrace: stackTrace);

// Log with context
AppLogger.instance.info(
  'User logged in',
  context: {'userId': user.id, 'tenantId': user.tenantId},
);
```

### 3. **Form Validators** ✅
Comprehensive form validation utilities.

#### Features:
- Email validation
- Password validation (simple and strong)
- Required field validation
- Phone number validation
- URL validation
- Min/max length validation
- Numeric validation
- Match validation (password confirmation)
- Combine multiple validators

#### Usage:
```dart
import 'package:core/core.dart';

// Single validator
AppTextField(
  label: 'Email',
  validator: Validators.email,
);

// Multiple validators
AppTextField(
  label: 'Password',
  validator: (value) => Validators.combine(value, [
    Validators.required,
    Validators.strongPassword,
  ]),
);

// Custom field name
AppTextField(
  label: 'Username',
  validator: (value) => Validators.minLength(value, 3, fieldName: 'Username'),
);

// Match validation (password confirmation)
AppTextField(
  label: 'Confirm Password',
  validator: (value) => Validators.match(
    value,
    passwordController.text,
    'Password',
  ),
);
```

### 4. **Internationalization (i18n)** 🌍
Built-in support for multiple languages.

#### Features:
- Base localization class
- English localizations included
- Easy to extend for other languages
- Parameter substitution in translations

#### Usage:
```dart
import 'package:core/core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// In MaterialApp
MaterialApp(
  localizationsDelegates: const [
    AppLocalizationsDelegate(),
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: const [
    Locale('en'),
  ],
  // ...
);

// In widgets
final l10n = AppLocalizations.of(context);
Text(l10n.get('welcome_back'));

// With parameters
Text(l10n.getWithParams('hello_user', {'name': user.name}));
```

#### Adding New Languages:
```dart
class VietnameseLocalizations extends AppLocalizations {
  @override
  final Locale locale = const Locale('vi');

  static final Map<String, String> _localizedValues = {
    'app_name': 'Ứng dụng SaaS',
    'login': 'Đăng nhập',
    'logout': 'Đăng xuất',
    // ... more translations
  };

  @override
  String get(String key) {
    return _localizedValues[key] ?? key;
  }

  @override
  String getWithParams(String key, Map<String, String> params) {
    var value = get(key);
    params.forEach((paramKey, paramValue) {
      value = value.replaceAll('{$paramKey}', paramValue);
    });
    return value;
  }
}

// Update delegate
@override
Future<AppLocalizations> load(Locale locale) async {
  switch (locale.languageCode) {
    case 'vi':
      return VietnameseLocalizations();
    case 'en':
    default:
      return EnglishLocalizations();
  }
}
```

### 5. **CI/CD Workflow** 🚀
GitHub Actions workflow for automated testing and building.

#### Features:
- **Analyze**: Runs Flutter analysis on all packages
- **Test**: Runs all unit tests
- **Format Check**: Ensures code is properly formatted
- **Build Android**: Creates release APK
- **Build iOS**: Creates iOS build (no codesign)

#### Workflow Triggers:
- Push to `main`, `develop`, or any `copilot/**` branch
- Pull requests to `main` or `develop`

#### Jobs:
```yaml
analyze → test → build-android
              → build-ios
format
```

#### Artifacts:
- APK artifact uploaded after successful build
- Available in Actions tab for 90 days

## 📦 Updated Dependencies

### Core Package
Add to `packages/core/pubspec.yaml`:
```yaml
dependencies:
  # ... existing dependencies
  flutter_localizations:
    sdk: flutter
```

### Settings Module
New dependencies in `packages/modules/settings_module/pubspec.yaml`:
```yaml
dependencies:
  image_picker: ^1.0.7  # For profile picture upload
```

## 🔧 Integration Guide

### 1. Add Settings Module to Your App

```dart
// In main.dart
final registry = ModuleRegistry();
await registry.registerAll([
  AuthModule(),
  DashboardModule(),
  UserModule(),
  SettingsModule(),  // Add this
]);
```

### 2. Enable Logging

```dart
// In main.dart, before runApp
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize logger
  AppLogger.instance.init(
    level: config.isDevelopment ? Level.debug : Level.warning,
  );
  
  // ... rest of initialization
}
```

### 3. Use Validators in Forms

Replace manual validation with utility validators:

```dart
// Before
validator: (value) {
  if (value == null || value.isEmpty) {
    return 'Email is required';
  }
  if (!value.contains('@')) {
    return 'Invalid email';
  }
  return null;
}

// After
validator: Validators.email,
```

### 4. Enable i18n

```dart
MaterialApp(
  localizationsDelegates: const [
    AppLocalizationsDelegate(),
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: const [
    Locale('en'),
    Locale('vi'),
  ],
  // ...
);
```

## 🎨 UI Updates

### Dashboard Screen
- Added settings icon button in app bar
- Clicking opens settings screen

### Settings Screen
- Clean, organized sections (Account, Preferences, About)
- Toggle switches for preferences
- Navigation to profile screen
- Logout with confirmation dialog

### Profile Screen
- Profile picture with camera icon for upload
- Editable name field
- Read-only email and tenant ID
- Save button with loading state

## 🧪 Testing

All new features include proper error handling and edge case management. Test by:

1. **Settings Module**:
   - Navigate to settings from dashboard
   - Toggle preferences (notifications, dark mode)
   - Change language
   - Navigate to profile and update name
   - Logout with confirmation

2. **Validators**:
   - Test with empty values
   - Test with invalid formats
   - Test with valid inputs
   - Test combined validators

3. **Logger**:
   - Check console output with different log levels
   - Verify context is displayed
   - Test error logging with stack traces

4. **CI/CD**:
   - Push to branch and check Actions tab
   - Verify all jobs pass
   - Download APK artifact

## 📈 Future Enhancements

Potential additions for next iteration:
- Push notifications integration
- Analytics tracking
- Offline data synchronization
- Advanced search functionality
- File upload/download manager
- Report generation
- Real-time updates with WebSockets
- Biometric authentication
- Two-factor authentication (2FA)

## 📝 Notes

- All new code follows Flutter best practices
- Null safety throughout
- Proper error handling
- Clean architecture maintained
- Documented with dartdoc comments
- Ready for production use
