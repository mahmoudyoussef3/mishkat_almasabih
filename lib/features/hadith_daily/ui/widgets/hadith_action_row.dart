import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/core/widgets/loading_progress_indicator.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/cubit/get_collections_bookmark_cubit.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/add_cubit/cubit/add_cubit_cubit.dart';
import 'package:mishkat_almasabih/features/bookmark/ui/widgets/add_bookmark_dialogs.dart';
import 'package:mishkat_almasabih/core/di/dependency_injection.dart';

class HadithActionsRow extends StatelessWidget {
  final String hadith;
  const HadithActionsRow({super.key, required this.hadith});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w, vertical: 16.h),
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
              Clipboard.setData(ClipboardData(text: hadith));
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
              await Share.share(hadith, subject: "شارك الحديث");
            },
          ),
          BlocConsumer<AddCubitCubit, AddCubitState>(
            listener: (context, state) {
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
                  showDialog(
                    context: context,
                    builder: (_) => MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (_) => getIt<GetCollectionsBookmarkCubit>(),
                        ),
                        BlocProvider(
                          create: (_) => getIt<AddCubitCubit>(),
                        ),
                      ],
                      child: AddToFavoritesDialog(
                        bookName: '',
                        bookSlug: '',
                        chapter: '',
                        hadithNumber: '',
                        hadithText: hadith,
                        id: '1',
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
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
