import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mishkat_almasabih/features/home/data/models/library_statistics_model.dart';
import 'package:mishkat_almasabih/features/home/data/repos/get_library_statistics_repo.dart';

part 'get_library_statistics_state.dart';

class GetLibraryStatisticsCubit extends Cubit<GetLibraryStatisticsState> {
  final GetLibraryStatisticsRepo _getLibraryStatisticsRepo;

  GetLibraryStatisticsCubit(this._getLibraryStatisticsRepo)
    : super(GetLibraryStatisticsInitial());

  /// Load statistics with caching logic
  Future<void> emitGetStatisticsCubit({bool forceRefresh = false}) async {
    emit(GetLivraryStatisticsLoading());

    try {
      final response = await _getLibraryStatisticsRepo.getLibraryStatistics();

      response.fold(
        (error) {
          log('❌ API Error: ${error.apiErrorModel.msg}');
          emit(GetLivraryStatisticsError(error.apiErrorModel.msg.toString()));
        },
        (apiData) async {
          emit(GetLivraryStatisticsSuccess(statisticsResponse: apiData));
        },
      );
    } catch (e) {
      log('❌ Unexpected error in statistics cubit: $e');
      emit(GetLivraryStatisticsError('حدث خطأ غير متوقع: $e'));
    }
  }
}
