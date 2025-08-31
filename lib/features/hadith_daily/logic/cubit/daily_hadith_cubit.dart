import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/models/hadith_daily_response.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/repos/hadith_daily_repo.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/repos/save_hadith_daily_repo.dart';

part 'daily_hadith_state.dart';

class DailyHadithCubit extends Cubit<DailyHadithState> {
  final HadithDailyRepo _hadithDailyRepo;
  DailyHadithCubit(this._hadithDailyRepo) : super(DailyHadithInitial());
  Future<void> loadOrFetchHadith() async {
    emit(DailyHaditLoading());

    final saved = await SaveHadithDailyRepo().getHadith();

    if (saved != null) {
      emit(DailyHadithSuccess(saved));
    } else {
      final result = await _hadithDailyRepo.getDailyHadith();

      result.fold(
        (l) => emit(
          DailyHadithFailure(l.apiErrorModel.msg ?? 'حدث خطأ. حاول مرة أخري'),
        ),
        (r) async {
          await SaveHadithDailyRepo().saveHadith(r);
          emit(DailyHadithSuccess(r));
        },
      );
    }
  }


  Future<void> fetchAndRefreshHadith() async {
  emit(DailyHaditLoading());

  final result = await _hadithDailyRepo.getDailyHadith();

  result.fold(
    (l) => emit(
      DailyHadithFailure(l.apiErrorModel.msg ?? 'حدث خطأ. حاول مرة أخري'),
    ),
    (r) async {
      await SaveHadithDailyRepo().saveHadith(r); 
      emit(DailyHadithSuccess(r));
    },
  );
}

}
