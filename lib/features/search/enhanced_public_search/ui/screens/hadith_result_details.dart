import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/di/dependency_injection.dart';
import 'package:mishkat_almasabih/core/helpers/extensions.dart';
import 'package:mishkat_almasabih/core/routing/routes.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/add_cubit/cubit/add_cubit_cubit.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/cubit/get_collections_bookmark_cubit.dart';
import 'package:mishkat_almasabih/features/bookmark/ui/widgets/add_bookmark_dialogs.dart';
import 'package:mishkat_almasabih/features/hadith_daily/ui/widgets/hadith_tabs.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_header_app_bar.dart';
import 'package:mishkat_almasabih/features/search/enhanced_public_search/data/models/enhanced_search_response_model.dart';
import 'package:mishkat_almasabih/features/search/enhanced_public_search/ui/widgets/result_hadith_action_row.dart';
import 'package:mishkat_almasabih/features/search/enhanced_public_search/ui/widgets/result_hadith_content_card.dart';
import 'package:mishkat_almasabih/features/search/enhanced_public_search/ui/widgets/result_hadith_tab_content.dart';
import 'package:mishkat_almasabih/features/search/enhanced_public_search/ui/widgets/search_hadith_attribution_and_grade.dart';
import 'package:mishkat_almasabih/features/serag/data/models/serag_request_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HadithResultDetails extends StatefulWidget {
  const HadithResultDetails({super.key, required this.enhancedHadithModel});
  final EnhancedHadithModel enhancedHadithModel;

  @override
  State<HadithResultDetails> createState() => _HadithDailyScreenState();
}

class _HadithDailyScreenState extends State<HadithResultDetails> {
  String selectedTab = "شرح";
  String? token;
  Future<void> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('token');

    setState(() {
      token = storedToken;
    });
  }

  @override
  void initState() {
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.enhancedHadithModel;

    return BlocProvider(
      create: (context) => getIt<AddCubitCubit>(),
      child: Builder(
        builder: (context) {
          return SafeArea(
              top: true,
        bottom: false,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                floatingActionButton: Builder(
                  builder: (context) {
                    return FloatingActionButton.extended(
                      onPressed:
                          token == null
                              ? () {
                                ScaffoldMessenger.of(context).showSnackBar(
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
                                            color:
                                                ColorsManager.secondaryBackground,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed:
                                              () => context.pushNamed(
                                                Routes.loginScreen,
                                              ),
                                          icon: Icon(
                                            Icons.login,
                                            color:
                                                ColorsManager.secondaryBackground,
                                          ),
                                        ),
                                      ],
                                    ),
                                    backgroundColor: ColorsManager.primaryGreen,
                                  ),
                                );
                              }
                              : () {
                                context.pushNamed(
                                  Routes.serag,
                                  arguments: SeragRequestModel(
                                    hadith: Hadith(
                                      hadeeth:
                                          widget.enhancedHadithModel.hadeeth ??
                                          '',
                                      grade_ar:
                                          widget.enhancedHadithModel.grade ?? '',
                                      source:
                                          widget.enhancedHadithModel.reference ??
                                          "",
                                      takhrij_ar:
                                          widget
                                              .enhancedHadithModel
                                              .attribution ??
                                          '',
                                    ),
                                    messages: [
                                      Message(role: 'user', content: ''),
                                    ],
                                  ),
                                );
                              },
                      backgroundColor: ColorsManager.primaryPurple,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      icon: CircleAvatar(
                        radius: 20.r,
                        backgroundImage: const AssetImage(
                          'assets/images/serag_logo.jpg',
                        ),
                        backgroundColor: Colors.transparent,
                      ),
                      label: Text(
                        "اسأل سراج",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: ColorsManager.secondaryBackground,
                        ),
                      ),
                    );
                  },
                ),
                backgroundColor: ColorsManager.primaryBackground,
                body: CustomScrollView(
                  slivers: [
                    BuildHeaderAppBar(
                      title: 'معلومات عن الحديث',
            
                      actions: [
                        AppBarActionButton(
                          icon: Icons.bookmark_border_rounded,
                          onPressed: () {
                            if (token == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: ColorsManager.primaryGreen,
                                  content: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'يجب تسجيل الدخول أولاً لاستخدام هذه الميزة',
                                        textDirection: TextDirection.rtl,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      IconButton(
                                        onPressed:
                                            () => context.pushNamed(
                                              Routes.loginScreen,
                                            ),
                                        icon: const Icon(
                                          Icons.login,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (dialogContext) {
                                  return MultiBlocProvider(
                                    providers: [
                                      BlocProvider(
                                        create: (_) => getIt<AddCubitCubit>(),
                                      ),
                                      BlocProvider(
                                        create:
                                            (_) =>
                                                getIt<
                                                    GetCollectionsBookmarkCubit
                                                  >()
                                                  ..getBookMarkCollections(),
                                      ),
                                    ],
                                    child: AddToFavoritesDialog(
                                      chapter: "",
                                      bookSlug: "",
                                      hadithNumber:
                                          widget.enhancedHadithModel.id ?? "",
                                      id:
                                          (Random().nextInt(10000000) + 1)
                                              .toString(),
                                      bookName:
                                          widget.enhancedHadithModel.reference ??
                                          "",
                                      hadithText:
                                          widget.enhancedHadithModel.hadeeth ??
                                          "",
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
            
                    SliverToBoxAdapter(child: SizedBox(height: 16.h)),
            
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (data.hadeeth != null)
                              Container(
                                margin: EdgeInsets.only(bottom: 10.h),
                                child: ResultHadithContentCard(
                                  data: widget.enhancedHadithModel,
                                ),
                              ),
                            Column(
                              children: [
                                SizedBox(height: 5.h),
                                Divider(
                                  endIndent: 30.w,
                                  indent: 30.w,
                                  color: ColorsManager.gray,
                                ),
                                SizedBox(height: 5.h),
                              ],
                            ),
                            searchHadithAttributionAndGrade(
                              enhancedHadithModel: widget.enhancedHadithModel,
                            ),
                            Column(
                              children: [
                                SizedBox(height: 5.h),
                                Divider(
                                  endIndent: 30.w,
                                  indent: 30.w,
                                  color: ColorsManager.gray,
                                ),
                                SizedBox(height: 5.h),
                              ],
                            ),
            
                            // Enhanced tabs section
                            Container(
                              margin: EdgeInsets.only(bottom: 20.h),
                              child: _buildEnhancedTabsSection(),
                            ),
            
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(color: ColorsManager.gray),
                              ),
                              child: ResultHadithTabContent(
                                selectedTab: selectedTab,
                                data: widget.enhancedHadithModel,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            
                    /*
                      SliverToBoxAdapter(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 20.h,
                          ),
                          child: _buildEnhancedActionsSection(),
                        ),
                      ),
                      */
                    SliverToBoxAdapter(child: SizedBox(height: 120.h)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEnhancedTabsSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      decoration: BoxDecoration(
        color: ColorsManager.white,

        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: ColorsManager.primaryPurple.withOpacity(0.08),
            blurRadius: 20.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: HadithTabs(
        selectedTab: selectedTab,
        onTabSelected: (tab) {
          setState(() => selectedTab = tab);
        },
      ),
    );
  }

  Widget _buildEnhancedActionsSection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            ColorsManager.primaryGreen.withOpacity(0.1),
            ColorsManager.primaryPurple.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: ColorsManager.primaryGold.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ResultHadithActionRow(
        author: widget.enhancedHadithModel.attribution ?? "",
        authorDeath: 'غير معروف',
        grade: widget.enhancedHadithModel.grade ?? '',
        isBookmarked: false,
        chapter: "",
        bookSlug: "",
        hadithNumber: widget.enhancedHadithModel.id ?? "",
        id: (Random().nextInt(10000000) + 1).toString(),
        bookName: widget.enhancedHadithModel.reference ?? "",
        hadith: widget.enhancedHadithModel.hadeeth ?? "",
      ),
    );
  }
}
