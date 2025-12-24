import 'package:flutter_test/flutter_test.dart';
import 'package:core/core.dart';

void main() {
  group('AppConfig', () {
    test('should create config with correct environment', () {
      final config = AppConfig(
        apiBaseUrl: 'https://api.example.com',
        environment: Environment.development,
        appName: 'Test App',
        version: '1.0.0',
      );

      expect(config.isDevelopment, isTrue);
      expect(config.isProduction, isFalse);
      expect(config.apiBaseUrl, 'https://api.example.com');
    });
  });

  group('ServiceLocator', () {
    test('should register and retrieve singleton', () {
      final sl = ServiceLocator.instance;
      final testObject = 'test';
      
      sl.registerSingleton<String>(testObject);
      
      expect(sl.isRegistered<String>(), isTrue);
      expect(sl.get<String>(), equals(testObject));
    });
  });
}
