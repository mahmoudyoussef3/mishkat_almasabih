import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mishkat_almasabih/features/home/data/models/library_statistics_model.dart';
import 'package:mishkat_almasabih/features/home/data/repos/cache_service.dart';
import 'package:mishkat_almasabih/features/home/data/repos/get_library_statistics_repo.dart';

part 'get_library_statistics_state.dart';

class GetLibraryStatisticsCubit extends Cubit<GetLibraryStatisticsState> {
  final GetLibraryStatisticsRepo _getLibraryStatisticsRepo;
  final CacheService _cacheService = CacheService.instance;

  GetLibraryStatisticsCubit(this._getLibraryStatisticsRepo)
      : super(GetLibraryStatisticsInitial());

  /// Load statistics with caching logic
  Future<void> emitGetStatisticsCubit({bool forceRefresh = false}) async {
    emit(GetLivraryStatisticsLoading());
    
    try {
      StatisticsResponse? data;

      if (!forceRefresh) {
        // Try to get from cache first
        log('📖 Attempting to load statistics from cache...');
        data = await _cacheService.getStatistics();
        
        if (data != null) {
          log('✅ Statistics loaded from cache successfully');
          emit(GetLivraryStatisticsSuccess(statisticsResponse: data));
          return;
        }
      }

      // If cache miss or force refresh, fetch from API
      log('🌐 Fetching statistics from API...');
      final response = await _getLibraryStatisticsRepo.getLibraryStatistics();

      response.fold(
        (error) {
          log('❌ API Error: ${error.apiErrorModel.msg}');
          emit(GetLivraryStatisticsError(error.apiErrorModel.msg.toString()));
        },
        (apiData) async {
          log('✅ Statistics fetched from API successfully');
          
          // Cache the new data
          final cacheResult = await _cacheService.saveStatistics(apiData);
          log('💾 Cache save result: $cacheResult');
          
          emit(GetLivraryStatisticsSuccess(statisticsResponse: apiData));
        },
      );
    } catch (e) {
      log('❌ Unexpected error in statistics cubit: $e');
      emit(GetLivraryStatisticsError('حدث خطأ غير متوقع: $e'));
    }
  }

  /// Force refresh data (clear cache and fetch new)
  Future<void> forceRefresh() async {
    log('🔄 Force refreshing statistics...');
    await _cacheService.clearStatisticsCache();
    await emitGetStatisticsCubit(forceRefresh: true);
  }

  /// Clear statistics cache
  Future<void> clearCache() async {
    await _cacheService.clearStatisticsCache();
    log('🗑️ Statistics cache cleared');
  }
}