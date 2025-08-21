import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/helpers/extensions.dart';
import 'package:mishkat_almasabih/core/routing/routes.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/core/theming/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuildHeaderAppBar extends StatelessWidget {
  const BuildHeaderAppBar({
    super.key,
    this.description,
    required this.title,
    this.home = false,
  });
  final String title;
  final String? description;
  final bool home;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      //  actions: [IconButton(onPressed: () {}, icon: Icon(Icons.logout,color: Colors.white,))],
      leading: IconButton(
        onPressed:
            home
                ? () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Directionality(
                        textDirection: TextDirection.rtl,
                        child: AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: const Text(
                            'تسجيل الخروج',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          content: const Text(
                            'هل أنت متأكد أنك تريد تسجيل الخروج؟',
                            style: TextStyle(fontSize: 16),
                          ),
                          actionsAlignment: MainAxisAlignment.start,
                          actions: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorsManager.primaryGreen,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () async {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.remove("token");

                                context.pushReplacementNamed(
                                  Routes.loginScreen,
                                );
                              },
                              child: const Text(
                                'نعم',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: ColorsManager.lightBlue,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'إلغاء',
                                style: TextStyle(
                                  color: ColorsManager.primaryGreen,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
                : null,
        icon: Icon(
          Icons.logout,
          color: home ? Colors.white : Colors.transparent,
        ),
      ),

      expandedHeight: 100.h,
      floating: true,
      pinned: home ? true : false,
      backgroundColor: ColorsManager.primaryPurple,
      flexibleSpace: FlexibleSpaceBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              title,
              style: TextStyles.displaySmall.copyWith(
                color: ColorsManager.white,
                fontWeight: FontWeight.bold,
                fontSize: 24.sp,
              ),
            ),
            Text(
              description ?? '',
              style: TextStyles.bodyMedium.copyWith(
                color: ColorsManager.white.withOpacity(0.9),
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
        centerTitle: true,
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [ColorsManager.primaryPurple, ColorsManager.primaryGreen],
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: 0.05,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/islamic_pattern.jpg'),
                        repeat: ImageRepeat.repeat,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
