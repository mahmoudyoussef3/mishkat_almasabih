// lib/core/config/app_config.dart

enum Environment {
  development,
  testing,
  production,
}

class AppConfig {
  AppConfig._();

  /// Current Environment
  static const String environment = String.fromEnvironment(
    'ENV',
    defaultValue: 'development',
  );

  /// Base URL
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://b88f-41-232-86-226.ngrok-free.app/api/V1',
  );

  /// Helpers
  static bool get isDevelopment => environment == 'development';

  static bool get isTesting => environment == 'testing';

  static bool get isProduction => environment == 'production';

  static Environment get env {
    switch (environment) {
      case 'production':
        return Environment.production;
      case 'testing':
        return Environment.testing;

      default:
        return Environment.development;
    }
  }
}
