import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/cubit/get_collections_bookmark_cubit.dart';
import 'package:mishkat_almasabih/features/bookmark/ui/widgets/add_bookmark_dialogs.dart';
import 'package:mishkat_almasabih/features/hadith_details/ui/widgets/hadith_books_section.dart';
import 'package:mishkat_almasabih/features/hadith_details/ui/widgets/hadith_grade_title.dart';
import 'package:mishkat_almasabih/features/hadith_details/ui/widgets/hadith_navigation.dart';
import 'package:mishkat_almasabih/core/di/dependency_injection.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/add_cubit/cubit/add_cubit_cubit.dart';
import 'package:mishkat_almasabih/features/hadith_details/ui/widgets/hadith_text_card.dart';
import 'package:mishkat_almasabih/features/navigation/logic/cubit/navigation_cubit.dart';
import 'package:share_plus/share_plus.dart';

class HadithDetailScreen extends StatefulWidget {
  final String? hadithText;
  final String? narrator;
  final String? grade;
  final String? bookName;
  final String? author;
  final String? chapter;
  final String? authorDeath;
  final String? hadithNumber;
  final String? bookSlug;
  final bool isBookMark;
  final String chapterNumber;

  const HadithDetailScreen({
    super.key,
    required this.hadithText,
    required this.chapterNumber,
    this.narrator,
    this.grade,
    this.bookName,
    this.author,
    required this.chapter,
    this.authorDeath,
    required this.hadithNumber,
    required this.bookSlug,
    this.isBookMark = false,
  });

  @override
  State<HadithDetailScreen> createState() => _HadithDetailScreenState();
}

class _HadithDetailScreenState extends State<HadithDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AddCubitCubit>()),
        BlocProvider(
          create:
              (context) =>
                  getIt<NavigationCubit>()..emitNavigationStates(
                    widget.hadithNumber.toString(),
                    widget.bookSlug ?? '',
                    widget.chapterNumber,
                  ),
        ),
      ],
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            foregroundColor: ColorsManager.primaryGreen,
            centerTitle: true,
            title: Text('تفاصيل الحديث', style: TextStyle(color: Colors.black)),
            backgroundColor: ColorsManager.secondaryBackground,
            elevation: 0,

            actions: [
              IconButton(
                color: ColorsManager.primaryGreen,
                onPressed: () async {
                  await Share.share(widget.hadithText!, subject: "شارك الحديث");
                },
                icon: Icon(Icons.share),
              ),

              if (!widget.isBookMark)
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (context) => MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create:
                                    (context) =>
                                        getIt<GetCollectionsBookmarkCubit>(),
                              ),
                              BlocProvider(
                                create: (context) => getIt<AddCubitCubit>(),
                              ),
                            ],
                            child: AddToFavoritesDialog(
                              bookName: widget.bookName ?? '',
                              bookSlug: widget.bookSlug ?? '',
                              chapter: widget.chapter ?? '',
                              hadithNumber: widget.hadithNumber ?? '',
                              hadithText: widget.hadithText ?? '',
                              id: widget.hadithNumber ?? '',
                            ),
                          ),
                    );
                  },
                  icon: Icon(Icons.favorite, color: ColorsManager.primaryGreen),
                ),
            ],
          ),
          backgroundColor: ColorsManager.primaryBackground,
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: SizedBox(height: 8.h)),

              SliverToBoxAdapter(
                child: HadithTextCard(hadithText: widget.hadithText!),
              ),

              if (widget.grade != null)
                SliverToBoxAdapter(
                  child: SizedBox(
                    child: HadithGradeTile(
                      grade: widget.grade!,
                      onTap: () {
                        Clipboard.setData(
                          ClipboardData(text: widget.hadithText ?? ''),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            behavior: SnackBarBehavior.floating,

                            content: Text("تم نسخ الحديث"),
                          ),
                        );
                      },
                    ),
                  ),
                ),

              _buildDivider(),

              SliverToBoxAdapter(
                child: HadithBookSection(
                  bookName: widget.bookName ?? '',
                  author: widget.author,
                  authorDeath: widget.authorDeath,
                  chapter: widget.chapter ?? "",
                ),
              ),

              _buildDivider(),

              if (!widget.isBookMark)
                SliverToBoxAdapter(
                  child: HadithNavigation(
                    hadithNumber: widget.hadithNumber ?? "",
                    bookSlug: widget.bookSlug ?? '',
                    chapterNumber: widget.chapterNumber,
                  ),
                ),

              SliverToBoxAdapter(child: SizedBox(height: 30.h)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Divider(
            color: ColorsManager.primaryNavy,
            endIndent: 30.h,
            indent: 30.h,
          ),
        ],
      ),
    );
  }
}
