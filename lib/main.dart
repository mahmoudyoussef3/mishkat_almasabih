import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/routing/app_router.dart';
import 'package:mishkat_almasabih/mishkat_almasabih.dart';

import 'core/di/dependency_injection.dart';
import 'package:device_preview/device_preview.dart';

void main() async {
  await setUpGetIt();
  await ScreenUtil.ensureScreenSize();
  runApp(
    //     DevicePreview(
    //     enabled: true,

    //     builder: (context) =>
    MishkatAlmasabih(appRouter: AppRouter()),
  );
  //);
}
