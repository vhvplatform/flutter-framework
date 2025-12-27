# Dependency Upgrade Notes

This document describes the dependency upgrades performed on December 27, 2025.

## Flutter SDK Upgrade

- **Previous version**: 3.16.0
- **New version**: 3.38.4 (with Dart 3.10.3)

The Flutter SDK has been upgraded to the latest stable version (3.38.4), which includes Dart 3.10.3. This version brings:
- Performance enhancements across all platforms
- Dot shorthands in Dart 3.10 for concise UI code
- Improved shader handling to reduce jank on mobile
- Faster web development cycles
- Better desktop platform support

### CI Workflow Updates

The `.github/workflows/ci.yml` file has been updated to use Flutter 3.38.4 across all jobs:
- analyze
- test
- format
- build-android
- build-ios

## Package Dependency Upgrades

### Core Package (`packages/core/pubspec.yaml`)

| Package | Previous Version | New Version | Notes |
|---------|-----------------|-------------|-------|
| dio | ^5.4.0 | ^5.4.3 | HTTP client - bug fixes and improvements |
| flutter_bloc | ^8.1.3 | ^8.1.3 | No change |
| provider | ^6.1.1 | ^6.1.1 | No change |
| shared_preferences | ^2.2.2 | ^2.2.2 | No change |
| flutter_secure_storage | ^9.0.0 | ^9.0.0 | No change |
| get_it | ^7.6.4 | ^9.2.0 | Major version upgrade - improved DI features |
| go_router | ^13.0.0 | ^13.0.0 | No change (already latest) |
| logger | ^2.0.2+1 | ^2.0.2 | Version normalization |
| equatable | ^2.0.5 | ^2.0.5 | No change |
| json_annotation | ^4.8.1 | ^4.9.0 | Minor update - new features |
| cached_network_image | ^3.3.1 | ^3.3.1 | No change |
| flutter_lints | ^3.0.0 | ^3.0.1 | Patch update - lint rule improvements |
| build_runner | ^2.4.7 | ^2.4.7 | No change (dev dependency) |
| json_serializable | ^6.7.1 | ^6.7.1 | No change (dev dependency) |

### UI Kit Package (`packages/ui_kit/pubspec.yaml`)

| Package | Previous Version | New Version | Notes |
|---------|-----------------|-------------|-------|
| cupertino_icons | ^1.0.6 | ^1.0.6 | No change |
| flutter_svg | ^2.0.9 | ^2.0.10 | Patch update - bug fixes |
| lottie | ^3.0.0 | ^3.3.1 | Minor update - new features and bug fixes |
| cached_network_image | ^3.3.1 | ^3.3.1 | No change |
| shimmer | ^3.0.0 | ^3.0.0 | No change |
| flutter_lints | ^3.0.0 | ^3.0.1 | Patch update - lint rule improvements |

### Module Packages

All module packages (auth_module, dashboard_module, user_module, settings_module) have been updated:

| Package | Previous Version | New Version | Notes |
|---------|-----------------|-------------|-------|
| provider | ^6.1.1 | ^6.1.1 | No change |
| image_picker | ^1.0.7 | ^1.0.7 | No change (settings_module only) |
| flutter_lints | ^3.0.0 | ^3.0.1 | Patch update - lint rule improvements |

### App Packages

Both app1 and app2 have been updated:

| Package | Previous Version | New Version | Notes |
|---------|-----------------|-------------|-------|
| provider | ^6.1.1 | ^6.1.1 | No change |
| cupertino_icons | ^1.0.6 | ^1.0.6 | No change |
| flutter_lints | ^3.0.0 | ^3.0.1 | Patch update - lint rule improvements |

## Breaking Changes

### get_it: 7.6.4 → 9.2.0

The get_it package has undergone a major version upgrade from 7.x to 9.x. Key breaking changes:

1. **Async Registration Improvements**: The async registration API has been refined. Make sure to check any custom async service registrations.

2. **Disposal Handling**: Enhanced disposal mechanics for registered instances. Review disposal logic if you have custom disposal handlers.

3. **Type Safety**: Improved type safety with stricter generics. This may require explicit type annotations in some cases.

**Migration Steps**:
- Review all `GetIt.instance.registerSingleton()` and `GetIt.instance.registerFactory()` calls
- Check async registrations with `registerSingletonAsync()`
- Test disposal of services during app lifecycle
- Refer to [get_it changelog](https://pub.dev/packages/get_it/changelog) for detailed migration guide

### flutter_lints: 3.0.0 → 3.0.1

This is a minor patch update with updated lint rules. You may need to:
- Address new lint warnings in your code
- Run `melos analyze` to see any new linting issues
- Update code style to match new best practices

### lottie: 3.0.0 → 3.3.1

This minor update includes:
- Improved animation performance
- Better null safety handling
- New customization options for animations

No breaking changes expected, but test all Lottie animations to ensure they render correctly.

## Testing Instructions

After pulling these changes:

1. **Bootstrap the project**:
   ```bash
   melos bootstrap
   ```

2. **Clean build artifacts** (recommended):
   ```bash
   melos clean
   melos bootstrap
   ```

3. **Run code generation** (if needed):
   ```bash
   melos generate
   ```

4. **Run analysis**:
   ```bash
   melos analyze
   ```
   Address any new lint warnings or errors.

5. **Run tests**:
   ```bash
   melos test
   ```
   Fix any failing tests.

6. **Test manually**:
   - Run app1: `cd apps/app1 && flutter run`
   - Run app2: `cd apps/app2 && flutter run`
   - Test key features:
     - Authentication flow
     - Navigation between screens
     - API calls
     - Local storage
     - Image loading and caching
     - Animations

## Compatibility Notes

- **Minimum Flutter SDK**: 3.0.0 (as specified in environment constraints)
- **Recommended Flutter SDK**: 3.38.4 (latest stable)
- **Dart SDK**: 3.0.0+ (bundled with Flutter)
- **Platform Support**: No changes to platform support
  - iOS 11.0+
  - Android API 21+
  - Web (Chrome, Firefox, Safari, Edge)
  - Desktop (Windows, macOS, Linux)

## CI/CD Impact

The CI pipeline has been updated to use Flutter 3.38.4. All jobs should continue to work:
- ✅ Code analysis
- ✅ Testing
- ✅ Format checking
- ✅ Android APK build
- ✅ iOS build (no codesign)

## Rollback Procedure

If issues are encountered, you can rollback by:

1. Reverting the commits in this PR
2. Running `melos clean && melos bootstrap`
3. The previous versions will be restored from git history

## Additional Resources

- [Flutter 3.38.4 Release Notes](https://docs.flutter.dev/release/release-notes)
- [Dart 3.10 Release Notes](https://dart.dev/guides/whats-new)
- [get_it Migration Guide](https://pub.dev/packages/get_it/changelog)
- [Melos Documentation](https://melos.invertase.dev/)

## Support

If you encounter any issues after this upgrade:
1. Check this document for known breaking changes
2. Review package changelogs on pub.dev
3. Run `flutter doctor -v` to check your Flutter installation
4. Create an issue in the repository with detailed error information
