import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mishkat_almasabih/core/cache/cache_mixin.dart';
import 'package:mishkat_almasabih/features/home/data/models/library_statistics_model.dart';
import 'package:mishkat_almasabih/features/home/data/repos/get_library_statistics_repo.dart';

part 'get_library_statistics_state.dart';

class GetLibraryStatisticsCubit extends Cubit<GetLibraryStatisticsState>
    with CacheMixin {
  GetLibraryStatisticsRepo _getLibraryStatisticsRepo;
  GetLibraryStatisticsCubit(this._getLibraryStatisticsRepo)
    : super(GetLibraryStatisticsInitial());

  Future<void> emitGetStatisticsCubit({bool forceRefresh = false}) async {
    const cacheKey = 'library_statistics';

    await loadWithCacheAndRefresh<StatisticsResponse>(
      cacheKey: cacheKey,
      apiCall: () async {
        final response = await _getLibraryStatisticsRepo.getLibraryStatistics();
        return response.fold(
          (error) => throw Exception(error.apiErrorModel.msg.toString()),
          (data) => data,
        );
      },
      fromJson: (json) => StatisticsResponse.fromJson(json),
      toJson: (data) => data.toJson(),
      onSuccess:
          (data) => emit(GetLivraryStatisticsSuccess(statisticsResponse: data)),
      onError: (error) => emit(GetLivraryStatisticsError(error)),
      loadingState: () => GetLivraryStatisticsLoading(),
      forceRefresh: forceRefresh,
      customCacheDuration: 120, // 2 hours cache for statistics
    );
  }
}
