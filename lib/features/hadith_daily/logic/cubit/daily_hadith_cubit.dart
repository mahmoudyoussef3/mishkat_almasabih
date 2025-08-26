import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/models/hadith_daily_response.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/repos/hadith_daily_repo.dart';

part 'daily_hadith_state.dart';

class DailyHadithCubit extends Cubit<DailyHadithState> {
  final HadithDailyRepo _hadithDailyRepo;
  DailyHadithCubit(this._hadithDailyRepo) : super(DailyHadithInitial());

  Future<void> emitHadithDaily() async {
    final result = await _hadithDailyRepo.getDailyHadith();

    result.fold(
      (l) => emit(DailyHadithFailure(l.apiErrorModel.msg ?? 'Error happened')),
      (r) {
        
        emit(DailyHadithSuccess(r));
      },
    );
  }
}
