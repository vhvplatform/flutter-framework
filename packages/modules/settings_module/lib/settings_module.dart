import 'package:flutter/widgets.dart';
import 'package:core/core.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';

/// Settings module
class SettingsModule extends AppModule {
  @override
  String get name => 'settings';

  @override
  String get version => '1.0.0';

  @override
  List<String> get dependencies => ['core', 'auth'];

  @override
  Future<void> initialize() async {
    // Register services if needed
  }

  @override
  Map<String, WidgetBuilder> registerRoutes() {
    return {
      '/settings': (context) => const SettingsScreen(),
      '/profile': (context) => const ProfileScreen(),
    };
  }

  @override
  void dispose() {
    // Cleanup if needed
  }
}
