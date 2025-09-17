import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mishkat_almasabih/features/home/data/models/library_statistics_model.dart';
import 'package:mishkat_almasabih/features/home/data/repos/get_library_statistics_repo.dart';

part 'get_library_statistics_state.dart';

class GetLibraryStatisticsCubit extends Cubit<GetLibraryStatisticsState> {
  final GetLibraryStatisticsRepo _getLibraryStatisticsRepo;
  GetLibraryStatisticsCubit(this._getLibraryStatisticsRepo)
    : super(GetLibraryStatisticsInitial());

  Future<void> emitGetStatisticsCubit() async {
    emit(GetLivraryStatisticsLoading());
    final response = await _getLibraryStatisticsRepo.getLibraryStatistics();

    response.fold(
      (error) =>
          emit(GetLivraryStatisticsError(error.apiErrorModel.msg.toString())),
      (data) {
        emit(GetLivraryStatisticsSuccess(statisticsResponse: data));
      },
    );
  }
}
