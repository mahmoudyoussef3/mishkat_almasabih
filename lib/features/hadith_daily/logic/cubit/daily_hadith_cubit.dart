import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mishkat_almasabih/core/cache/cache_mixin.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/models/hadith_daily_response.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/repos/hadith_daily_repo.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/repos/save_hadith_daily_repo.dart';

part 'daily_hadith_state.dart';

class DailyHadithCubit extends Cubit<DailyHadithState> with CacheMixin {
  final HadithDailyRepo _hadithDailyRepo;
  DailyHadithCubit(this._hadithDailyRepo) : super(DailyHadithInitial());

  Future<void> loadOrFetchHadith({bool forceRefresh = false}) async {
    const cacheKey = 'daily_hadith';

    await loadWithCacheAndRefresh<HadithDailyResponse>(
      cacheKey: cacheKey,
      apiCall: () async {
        final result = await _hadithDailyRepo.getDailyHadith();
        return result.fold(
          (error) =>
              throw Exception(
                error.apiErrorModel.msg ?? 'حدث خطأ. حاول مرة أخري',
              ),
          (data) => data,
        );
      },
      fromJson: (json) => HadithDailyResponse.fromJson(json),
      toJson: (data) => data.toJson(),
      onSuccess: (data) async {
        // Also save using the existing save mechanism for backward compatibility
        await SaveHadithDailyRepo().saveHadith(data);
        emit(DailyHadithSuccess(data));
      },
      onError: (error) => emit(DailyHadithFailure(error)),
      loadingState: () => DailyHaditLoading(),
      forceRefresh: forceRefresh,
      customCacheDuration: 1440, // 24 hours cache for daily hadith
    );
  }

  Future<void> fetchAndRefreshHadith() async {
    await loadOrFetchHadith(forceRefresh: true);
  }
}
