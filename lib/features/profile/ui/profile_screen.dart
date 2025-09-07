import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/profile/logic/cubit/profile_cubit.dart';
import 'package:mishkat_almasabih/features/profile/ui/widgets/socila_media_icons.dart';
import 'widgets/profile_header.dart';
import 'widgets/section_title.dart';
import 'widgets/dark_mode_toggle.dart';
import 'widgets/profile_option_tile.dart';
import 'widgets/logout_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ProfileCubit>().getUserProfile();

    return RefreshIndicator(
      onRefresh: () async {
      
        await context.read<ProfileCubit>().getUserProfile();
      },
      child: Scaffold(
        backgroundColor: ColorsManager.primaryBackground,
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: ColorsManager.primaryPurple,
                ),
              );
            } else if (state is ProfileError) {
              return Center(
                child: Text(
                  "حدث خطأ أثناء تحميل البيانات",
                  style: TextStyle(fontSize: 16.sp, color: ColorsManager.error),
                ),
              );
            } else if (state is ProfileLoaded) {
              final user = state.user;
      
              return CustomScrollView(
                slivers: [
                  ProfileHeader(user: user),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 20.h),
                      child: Column(
                        children: [
                          const SectionTitle(title: "الإعدادات"),
                          SizedBox(height: 16.h),
                          const DarkModeToggle(),
                          SizedBox(height: 24.h),
                          ProfileOptionTile(
                            icon: Icons.privacy_tip,
                            title: "سياسة الخصوصية",
                            subtitle: "اقرأ سياسة الخصوصية",
                            url: 'https://hadith-shareef.com/privacy-policy',
                          ),
                          SizedBox(height: 24.h),
                          const SectionTitle(title: "تواصل معنا"),
                          SizedBox(height: 24.h),
                          const SocialMediaIcons(),
                          SizedBox(height: 46.h),
                          LogoutButton(),
                                                  SizedBox(height: 46.h),
      
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
