import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/helpers/extensions.dart';
import 'package:mishkat_almasabih/core/routing/routes.dart';
import 'package:mishkat_almasabih/core/widgets/loading_progress_indicator.dart';
import 'package:mishkat_almasabih/features/home/logic/cubit/get_library_statistics_cubit.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_book_data_state_card.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_header_app_bar.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/build_main_category_card.dart';
import 'package:mishkat_almasabih/features/home/ui/widgets/search_bar_widget.dart';
import 'package:mishkat_almasabih/features/library/ui/screens/library_screen.dart';
import '../../../core/theming/colors.dart';
import '../../../core/theming/styles.dart';
import '../../../core/helpers/spacing.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getLibraryStatistics();
  }

  Future<void> getLibraryStatistics() async {
    await context.read<GetLibraryStatisticsCubit>().emitGetStatisticsCubit();
  }
  final _controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorsManager.primaryBackground,
        body: BlocBuilder<GetLibraryStatisticsCubit, GetLibraryStatisticsState>(
          builder: (context, state) {
            if (state is GetLivraryStatisticsLoading) {
              return loadingProgressIndicator();
            } else if (state is GetLivraryStatisticsSuccess) {
              return CustomScrollView(
                slivers: [
                  BuildHeaderAppBar(
                    home: true,
                    title: 'مشكاة المصابيح',
                    description: 'مكتبة مشكاة الإسلامية',
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 20.h)),
                  // PublicSearchResult(),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Spacing.screenHorizontal,
                      ),
                      child: SearchBarWidget(
                        controller: _controller,
                        onSearch: (query) {
                          if (query.isNotEmpty) {
                            context.pushNamed(
                              Routes.publicSearchSCreen,
                              arguments: _controller.text,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(Spacing.screenHorizontal),
                      child: Row(
                        children: [
                          Expanded(
                            child: BuildBookDataStateCard(
                              icon: Icons.book,
                              title: 'إجمالي الكتب',
                              value:
                                  state.statisticsResponse.statistics.totalBooks
                                      .toString(),
                              color: ColorsManager.primaryPurple,
                            ),
                          ),
                          SizedBox(width: Spacing.md),
                          Expanded(
                            child: BuildBookDataStateCard(
                              icon: Icons.folder,
                              title: 'الأبواب',
                              value:
                                  state
                                      .statisticsResponse
                                      .statistics
                                      .totalChapters
                                      .toString(),

                              color: ColorsManager.hadithAuthentic,
                            ),
                          ),
                          SizedBox(width: Spacing.md),
                          Expanded(
                            child: BuildBookDataStateCard(
                              icon: Icons.format_quote,
                              title: 'الأحاديث',
                              value:
                                  state
                                      .statisticsResponse
                                      .statistics
                                      .totalHadiths
                                      .toString(),

                              color: ColorsManager.primaryGold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Divider(
                      color: ColorsManager.primaryNavy,
                      endIndent: 30.h,
                      indent: 30.h,
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(Spacing.screenHorizontal),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'الكتب الرئيسية',
                            style: TextStyles.headlineMedium.copyWith(
                              color: ColorsManager.primaryText,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: Spacing.md),

                          BuildMainCategoryCard(
                            title:
                                state
                                    .statisticsResponse
                                    .statistics
                                    .booksByCategory['kutub_tisaa']!
                                    .name,
                            subtitle: '11 كتاب',
                            description: 'المجاميع الكبيرة للأحاديث الصحيحة',
                            icon: Icons.library_books,
                            bookCount:
                                state
                                    .statisticsResponse
                                    .statistics
                                    .booksByCategory['kutub_tisaa']!
                                    .count,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                ColorsManager.primaryPurple,
                                ColorsManager.primaryGreen,
                              ],
                            ),
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return LibraryScreen(
                                      name: "كتب الأحاديث الكبيرة",
                                      id: 'kutub_tisaa',
                                    );
                                  },
                                ),
                              );
                            },
                          ),

                          SizedBox(height: Spacing.md),

                          BuildMainCategoryCard(
                            title:
                                state
                                    .statisticsResponse
                                    .statistics
                                    .booksByCategory['arbaain']!
                                    .name,
                            subtitle: '3 كتب',
                            description: 'مجموعات الأربعين حديثاً',
                            icon: Icons.format_list_numbered,
                            bookCount:
                                state
                                    .statisticsResponse
                                    .statistics
                                    .booksByCategory['arbaain']!
                                    .count,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                ColorsManager.primaryPurple,
                                ColorsManager.primaryGreen,
                              ],
                            ),
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return LibraryScreen(
                                      name: 'كتب الأربعينات',
                                      id: 'arbaain',
                                    );
                                  },
                                ),
                              );
                            },
                          ),

                          SizedBox(height: Spacing.md),

                          BuildMainCategoryCard(
                            title:
                                state
                                    .statisticsResponse
                                    .statistics
                                    .booksByCategory['adab']!
                                    .name,
                            subtitle: '3 كتب',
                            description: 'كتب الآداب والأخلاق الإسلامية',
                            icon: Icons.psychology,
                            bookCount:
                                state
                                    .statisticsResponse
                                    .statistics
                                    .booksByCategory['adab']!
                                    .count,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                ColorsManager.primaryPurple,
                                ColorsManager.primaryGreen,
                              ],
                            ),
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return LibraryScreen(
                                      name: 'كتب الأدب و الآداب',
                                      id: 'adab',
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: Spacing.xl)),
                ],
              );
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
