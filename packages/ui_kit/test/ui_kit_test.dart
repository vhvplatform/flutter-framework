import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

void main() {
  group('AppTheme', () {
    test('should have light and dark themes', () {
      expect(AppTheme.lightTheme, isNotNull);
      expect(AppTheme.darkTheme, isNotNull);
    });
  });

  group('AppColors', () {
    test('should have defined colors', () {
      expect(AppColors.primary, isNotNull);
      expect(AppColors.secondary, isNotNull);
      expect(AppColors.white, isNotNull);
    });
  });
}
