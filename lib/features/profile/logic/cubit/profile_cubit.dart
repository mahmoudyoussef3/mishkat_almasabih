import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mishkat_almasabih/core/cache/cache_mixin.dart';
import 'package:mishkat_almasabih/features/profile/data/models/user_response_model.dart';
import 'package:mishkat_almasabih/features/profile/data/repos/user_response_repo.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> with CacheMixin {
  final UserResponseRepo userResponseRepo;
  ProfileCubit(this.userResponseRepo) : super(ProfileInitial());

  Future<void> getUserProfile({bool forceRefresh = false}) async {
    const cacheKey = 'user_profile';

    await loadWithCacheAndRefresh<UserResponseModel>(
      cacheKey: cacheKey,
      apiCall: () async {
        final result = await userResponseRepo.getUserProfile();
        return result.fold(
          (error) => throw Exception(error.apiErrorModel.msg.toString()),
          (data) => data,
        );
      },
      fromJson: (json) => UserResponseModel.fromJson(json),
      toJson: (data) => data.toJson(),
      onSuccess: (data) => emit(ProfileLoaded(data)),
      onError: (error) => emit(ProfileError(error)),
      loadingState: () => ProfileLoading(),
      forceRefresh: forceRefresh,
      customCacheDuration: 15, // 15 minutes cache for user profile
    );
  }
}
