
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mishkat_almasabih/features/ahadith/data/models/ahadiths_model.dart';
import 'package:mishkat_almasabih/features/ahadith/data/models/local_books_model.dart';
import 'package:mishkat_almasabih/features/ahadith/data/repos/ahadiths_repo.dart';

part 'ahadiths_state.dart';

class AhadithsCubit extends Cubit<AhadithsState> {
  final AhadithsRepo _chapterAhadithsRepo;
  AhadithsCubit(this._chapterAhadithsRepo) : super(AhadithsInitial());
  late LocalHadithResponse localHadithResponse;

  Future<void> emitAhadiths({
    required String bookSlug,
    required int chapterId,
    required bool hadithLocal,
    required bool isArbainBooks,
  }) async {
    emit(AhadithsLoading());

    if (isArbainBooks) {
      final result = await _chapterAhadithsRepo.getThreeBooksLocalAhadith(
        bookSlug: bookSlug,
        chapterId: chapterId,
      );
      result.fold(
        (l) => emit(AhadithsFailure(l.apiErrorModel.msg!)),
        (r) => emit(LocalAhadithsSuccess(r)),
      );
    } else if (hadithLocal) {
      final result = await _chapterAhadithsRepo.getLocalAhadith(
        bookSlug: bookSlug,
        chapterId: chapterId,
      );
      result.fold(
        (l) => emit(AhadithsFailure(l.apiErrorModel.msg!)),
        (r) => emit(LocalAhadithsSuccess(r)),
      );
    } else {
      final result = await _chapterAhadithsRepo.getAhadith(
        bookSlug: bookSlug,
        chapterId: chapterId,
      );
      result.fold(
        (l) => emit(AhadithsFailure(l.apiErrorModel.msg!)),
        (r) => emit(AhadithsSuccess(r)),
      );
    }
  }
}
