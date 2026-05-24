import 'package:flutter_test/flutter_test.dart';
import 'package:mishkat_almasabih/core/config/config.dart';

void main() {
  group('appConfigForFlavor', () {
    test('returns development config', () {
      final config = appConfigForFlavor(AppFlavor.development);

      expect(config.flavor, AppFlavor.development);
      expect(config.appName, 'App Dev');
      expect(config.bannerMessage, 'DEV MODE');
      expect(config.isDevelopment, isTrue);
      expect(config.showFlavorBanner, isTrue);
    });

    test('returns production config', () {
      final config = appConfigForFlavor(AppFlavor.production);

      expect(config.flavor, AppFlavor.production);
      expect(config.appName, 'App');
      expect(config.bannerMessage, isNull);
      expect(config.isDevelopment, isFalse);
      expect(config.showFlavorBanner, isFalse);
    });

    test('defaultAppConfig returns development config outside release', () {
      final config = defaultAppConfig(isReleaseMode: false);

      expect(config.flavor, AppFlavor.development);
      expect(config.appName, 'App Dev');
    });

    test('defaultAppConfig returns production config in release', () {
      final config = defaultAppConfig(isReleaseMode: true);

      expect(config.flavor, AppFlavor.production);
      expect(config.appName, 'App');
    });
  });
}
