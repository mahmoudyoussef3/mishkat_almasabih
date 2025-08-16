import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/routing/app_router.dart';
import 'package:mishkat_almasabih/firebase_options.dart';
import 'package:mishkat_almasabih/mishkat_almasabih.dart';

import 'core/di/dependency_injection.dart';
import 'package:device_preview/device_preview.dart';

void main() async {
  await setUpGetIt();
  await ScreenUtil.ensureScreenSize();
    WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    DevicePreview(
      enabled: true,

      builder: (context) => MishkatAlmasabih(appRouter: AppRouter()),
    ),
  );
}
