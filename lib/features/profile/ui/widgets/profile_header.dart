import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat_almasabih/core/di/dependency_injection.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';
import 'package:mishkat_almasabih/features/profile/data/models/user_response_model.dart';
import 'package:mishkat_almasabih/features/profile/edit_profile/logic/cubit/edit_profile_cubit.dart';
import 'package:mishkat_almasabih/features/profile/edit_profile/ui/edit_profile_screen.dart';

class ProfileHeader extends StatelessWidget {
  final UserResponseModel user;
  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      foregroundColor: ColorsManager.secondaryBackground,
      expandedHeight: 180,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                ColorsManager.primaryPurple,
                ColorsManager.secondaryPurple,
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.transparent,
                  backgroundImage:
                      (user.avatarUrl?.isNotEmpty ?? false)
                          ? NetworkImage(user.avatarUrl!)
                          : null,
                  child:
                      (user.avatarUrl?.isEmpty ?? true)
                          ? const Icon(
                            Icons.person,
                            size: 60,
                            color: ColorsManager.secondaryBackground,
                          )
                          : null,
                ),
                const SizedBox(height: 16),
                Text(
                  user.username ?? "المستخدم",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  user.email ?? "user@example.com",
                  style: TextStyle(
                    fontSize: 15,
                    color: ColorsManager.white.withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => BlocProvider(
                      create: (context) => getIt<EditProfileCubit>(),
                      child: EditProfileScreen(userData: user),
                    ),
              ),
            );
          },
          icon: const Icon(Icons.edit, color: Colors.white),
        ),
      ],
    );
  }
}
