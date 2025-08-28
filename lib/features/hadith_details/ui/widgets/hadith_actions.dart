import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/di/dependency_injection.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/add_cubit/cubit/add_cubit_cubit.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/cubit/get_collections_bookmark_cubit.dart';
import 'package:mishkat_almasabih/features/bookmark/ui/widgets/add_bookmark_dialogs.dart';
import 'package:mishkat_almasabih/features/hadith_details/ui/widgets/action_button.dart';
import 'package:share_plus/share_plus.dart';

class HadithActions extends StatelessWidget {
  final String hadithText;
  final bool isBookMark;
  final String bookName;
  final String bookSlug;
  final String chapter;
  final String hadithNumber;

  const HadithActions({
    super.key,
    required this.hadithText,
    required this.isBookMark,
    required this.bookName,
    required this.bookSlug,
    required this.chapter,
    required this.hadithNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: ColorsManager.primaryPurple.withOpacity(0.1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ActionButton(
              icon: Icons.copy,
              label: "نسخ",
              onTap: () {
                Clipboard.setData(ClipboardData(text: hadithText));
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(
                  
                                                      behavior: SnackBarBehavior.floating,

                  content: Text("تم نسخ الحديث")));
              },
            ),
            ActionButton(
              icon: Icons.share,
              label: "مشاركة",
              onTap: () async {
                await Share.share(hadithText, subject: "شارك الحديث");
              },
            ),
            if (!isBookMark)
              ActionButton(
                icon: Icons.bookmark,
                label: "حفظ",
                onTap: () {
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
                            bookName: bookName,
                            bookSlug: bookSlug,
                            chapter: chapter,
                            hadithNumber: hadithNumber,
                            hadithText: hadithText,
                            id: hadithNumber,
                          ),
                        ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
