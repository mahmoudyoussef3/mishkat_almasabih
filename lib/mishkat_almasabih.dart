import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/routing/app_router.dart';
import 'core/routing/routes.dart';
import 'core/theming/app_theme.dart';

class MishkatAlmasabih extends StatelessWidget {
  final AppRouter appRouter;
  const MishkatAlmasabih({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Mishkat Almasabih',
          theme: ThemeData(fontFamily:  'YaModernPro',
          ),
//          theme: AppTheme.lightTheme,
  //        darkTheme: AppTheme.darkTheme,
          debugShowCheckedModeBanner: false,
          initialRoute: Routes.mainNavigationScreen,
          onGenerateRoute: appRouter.generateRoute,
        );
      },
    );
  }
}
