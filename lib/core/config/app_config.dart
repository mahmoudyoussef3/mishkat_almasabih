import 'app_flavor.dart';

class AppConfig {
  final AppFlavor flavor;
  final String appName;
  final String? bannerMessage;

  const AppConfig({
    required this.flavor,
    required this.appName,
    this.bannerMessage,
  });

  const AppConfig.development()
    : flavor = AppFlavor.development,
      appName = 'App Dev',
      bannerMessage = 'DEV MODE';

  const AppConfig.production()
    : flavor = AppFlavor.production,
      appName = 'App',
      bannerMessage = null;

  bool get isDevelopment => flavor == AppFlavor.development;

  bool get showFlavorBanner => bannerMessage != null;
}
