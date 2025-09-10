import 'package:dio/dio.dart';
import 'package:easy_notify/easy_notify.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mishkat_almasabih/core/networking/api_constants.dart';
import 'package:mishkat_almasabih/core/networking/api_service.dart';
import 'package:mishkat_almasabih/core/routing/app_router.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/models/hadith_daily_response.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/repos/hadith_daily_repo.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/repos/save_hadith_daily_repo.dart';
import 'package:mishkat_almasabih/features/hadith_daily/logic/cubit/daily_hadith_cubit.dart';
import 'package:mishkat_almasabih/features/notification/local_notification_service.dart';
import 'package:mishkat_almasabih/features/onboarding/sava_date_for_first_time.dart';
import 'package:mishkat_almasabih/mishkat_almasabih.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;


import 'core/di/dependency_injection.dart';
import 'package:device_preview/device_preview.dart';

const fetchTaskKey = "fetchApiTask";
/*

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      if (task == fetchTaskKey) {
        print('go in first check');
        // 1) امسح الحديث القديم
        await SaveHadithDailyRepo().deleteHadith();
        print('go in second check');

        // 2) هات الحديث الجديد من API
        final newHadith =
            await HadithDailyRepo(
              ApiService(Dio(), baseUrl: ApiConstants.apiBaseUrl),
            ).getDailyHadith();
                    print('go in third check');


        // 3) خزنه في SharedPreferences
        await SaveHadithDailyRepo().saveHadith(
          newHadith.fold(
            (l) => DailyHadithModel(
              data: HadithData(title: 'حدث خطأ في تحميل الحديث'),
            ),
            (r) => r,
          ),
        );
                print('go in fourth check');

      }
    } catch (e, s) {
              print('go in zero check');

      // ممكن تخزن اللوج هنا لو حابب
      debugPrint("Error in background task: $e\n$s");
    }

    return Future.value(true);
  });
}*/


void main() async {

/*  WidgetsFlutterBinding.ensureInitialized();

  await setUpGetIt();
  tz.initializeTimeZones();
  await EasyNotify.init();
  await EasyNotifyPermissions.requestAll();
  /*
  final intentThree = const AndroidIntent(action: 'android.settings.SETTINGS');
  await intentThree.launch();
  const intent = AndroidIntent(
    action: 'android.settings.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS',
    data: 'package:com.yourcompany.yourapp',
  );
  await intent.launch();
  const intentTwo = AndroidIntent(
    action: 'android.settings.IGNORE_BATTERY_OPTIMIZATION_SETTINGS',
  );
  await intentTwo.launch();
  */

  final isFirstTime = await SaveDataForFirstTime.isFirstTime();

  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  final bool isLoggedIn = token != null;

  await ScreenUtil.ensureScreenSize();

 /* await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  
    await Workmanager().registerPeriodicTask(
    "fetchTask_24h",
    fetchTaskKey,
    frequency: const Duration(hours: 24),
  );

  // تاسك تجريبي (مش هيشتغل أقل من 15 دقيقة في الواقع)
  await Workmanager().registerPeriodicTask(
    "fetchTask_debug",
    fetchTaskKey,
    frequency: const Duration(minutes: 15),
  );
 */
*/
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Initialize EasyNotify
  await EasyNotify.init();
  
  // Initialize Cyclic Service
  await CyclicDataService.initialize();
  
  runApp(const CyclicDataApp());
  /*
  runApp(
    DevicePreview(
      enabled: true,
      builder:
          (context) => MishkatAlmasabih(
            appRouter: AppRouter(),
            isFirstTime: isFirstTime,
            isLoggedIn: isLoggedIn,
          ),
    ),
  );
  */
}
