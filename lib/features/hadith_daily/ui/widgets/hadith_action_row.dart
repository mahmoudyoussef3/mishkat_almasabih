import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mishkat_almasabih/core/helpers/extensions.dart';
import 'package:mishkat_almasabih/core/routing/routes.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/core/widgets/loading_progress_indicator.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/cubit/get_collections_bookmark_cubit.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/add_cubit/cubit/add_cubit_cubit.dart';
import 'package:mishkat_almasabih/features/bookmark/ui/widgets/add_bookmark_dialogs.dart';
import 'package:mishkat_almasabih/core/di/dependency_injection.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

class HadithActionsRow extends StatefulWidget {
  final String hadith;
  final String bookName;
  final String bookSlug;
  final String chapter;
  final String hadithNumber;
  final String id;
  final String? author;
  final String? authorDeath;
  final String? grade;
  bool isBookmarked;
  HadithActionsRow({
    super.key,
    required this.hadith,
    required this.bookName,
    required this.bookSlug,
    required this.chapter,
    required this.hadithNumber,
    required this.id,
    this.isBookmarked = false,
    required this.author,
    required this.authorDeath,
    required this.grade,
  });

  @override
  State<HadithActionsRow> createState() => _HadithActionsRowState();
}

bool hasToken = false;

class _HadithActionsRowState extends State<HadithActionsRow> {
  Future<void> _checkToken(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('token');
    if (storedToken != null) {
      hasToken = true;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkToken(context);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<GetCollectionsBookmarkCubit>()),
        BlocProvider(create: (_) => getIt<AddCubitCubit>()),
      ],
      child: Container(
        padding: EdgeInsetsDirectional.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: ColorsManager.primaryPurple.withOpacity(0.1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildActionButton(
              icon: Icons.copy,
              label: "نسخ",
              onTap: () {
                Clipboard.setData(ClipboardData(text: widget.hadith));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text("تم نسخ الحديث"),
                  ),
                );
              },
            ),
            _buildActionButton(
              icon: Icons.share,
              label: "مشاركة",
              onTap: () async {
                await Share.share(widget.hadith, subject: "شارك الحديث");
              },
            ),

            if (!widget.isBookmarked)
              BlocConsumer<AddCubitCubit, AddCubitState>(
                listener: (context, state) {
                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).clearSnackBars();
                  if (state is AddLoading) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: ColorsManager.primaryGreen,
                        content: loadingProgressIndicator(
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    );
                  } else if (state is AddSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.green,
                        content: Text("تم حفظ الحديث"),
                      ),
                    );
                  } else if (state is AddFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text("حدث خطأ. حاول مرة أخرى"),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return _buildActionButton(
                    icon: Icons.bookmark,
                    label: "حفظ",
                    onTap: () {
                      hasToken
                          ? showDialog(
                            context: context,
                            builder: (dialogContext) {
                              return MultiBlocProvider(
                                providers: [
                                  BlocProvider.value(
                                    value:
                                        context
                                            .read<
                                              GetCollectionsBookmarkCubit
                                            >(),
                                  ),
                                  BlocProvider.value(
                                    value: context.read<AddCubitCubit>(),
                                  ),
                                ],
                                child: AddToFavoritesDialog(
                                  bookName: widget.bookName,
                                  bookSlug: widget.bookSlug,
                                  chapter: widget.chapter,
                                  hadithNumber: widget.hadithNumber,
                                  hadithText: widget.hadith,
                                  id: widget.id,
                                ),
                              );
                            },
                          )
                          : ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              //  behavior: SnackBarBehavior.floating,
                              content: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'يجب تسجيل الدخول أولاً لاستخدام هذه الميزة',
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      color: ColorsManager.secondaryBackground,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed:
                                        () => context.pushNamed(
                                          Routes.loginScreen,
                                        ),
                                    icon: Icon(
                                      Icons.login,
                                      color: ColorsManager.secondaryBackground,
                                    ),
                                  ),
                                ],
                              ),
                              backgroundColor: ColorsManager.primaryGreen,
                            ),
                          );
                    },
                  );
                },
              ),

            /*
              
                 Flexible(
                child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
                        child: Column(
                          children: [
                            Icon(
                FontAwesomeIcons.userLock,
                size: 70.sp,
                color: ColorsManager.primaryPurple,
                            ),
                            SizedBox(height: 12.h),
                            Text(
                "يجب تسجيل الدخول لعرض بيانات الملف الشخصي",
                style: TextStyle(
                  fontSize: 15.sp,
                  color: ColorsManager.darkGray,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16.h),
                            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManager.primaryGreen,
                  padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text(
                  "تسجيل الدخول",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                            ),
                          ],
                        ),
                      ),
                ),
              )
  
*/
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      //borderRadius: BorderRadius.circular(12.r),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: ColorsManager.primaryPurple.withOpacity(0.1),
            child: Icon(icon, color: ColorsManager.primaryPurple),
          ),
          SizedBox(height: 6.h),
          Text(
            label,
            style: TextStyle(fontSize: 13.sp, color: ColorsManager.darkGray),
          ),
        ],
      ),
    );
  }
}
