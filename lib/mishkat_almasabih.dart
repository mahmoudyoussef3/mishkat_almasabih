import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/deep_links/deep_link_router.dart';
import 'package:mishkat_almasabih/core/helpers/deep_linker_helper.dart';
import 'package:mishkat_almasabih/core/notification/firebase_service/notification_handler.dart';
import 'core/routing/app_router.dart';
import 'core/routing/routes.dart';

class MishkatAlmasabih extends StatefulWidget {
  final AppRouter appRouter;
  final bool isFirstTime;
  final NavigatorObserver analytics;

  const MishkatAlmasabih({
    super.key,
    required this.appRouter,
    required this.isFirstTime,
    required this.analytics,
  });

  @override
  State<MishkatAlmasabih> createState() => _MishkatAlmasabihState();
}

class _MishkatAlmasabihState extends State<MishkatAlmasabih> {
  final DeepLinkHandler _deepLinkHandler = DeepLinkHandler();

  late final String _startScreen;

  @override
  void initState() {
    super.initState();

    // ✅ نحسب البداية مرة واحدة بس
    _startScreen =
        widget.isFirstTime ? Routes.onBoardingScreen : Routes.splashScreen;

    log("Start screen: $_startScreen");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(
        _deepLinkHandler.init((uri) async {
          if (kDebugMode) debugPrint('Received deep link: $uri');
          await DeepLinkRouter.handle(uri);
        }),
      );
    });
  }

  @override
  void dispose() {
    _deepLinkHandler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          navigatorObservers: [widget.analytics],
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: 'Cairo', useMaterial3: true),

        
          // ✅ استخدم القيمة المحفوظة
          initialRoute: _startScreen,

          onGenerateRoute: widget.appRouter.generateRoute,

          // ❗ مهم جدًا debugging
          onUnknownRoute: (settings) {
            log("❌ Unknown route: ${settings.name}");
            return MaterialPageRoute(
              builder:
                  (_) => const Scaffold(
                    body: Center(child: Text('Route not found')),
                  ),
            );
          },
        );
      },
    );
  }
}
