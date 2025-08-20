import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mishkat_almasabih/features/get_chapter_ahadith/data/models/chapter_ahadiths_model.dart';
import 'package:mishkat_almasabih/features/get_chapter_ahadith/data/models/local_books_model.dart';
import 'package:mishkat_almasabih/features/get_chapter_ahadith/data/repos/chapter_ahadiths_repo.dart';

part 'get_chapter_ahadiths_state.dart';

class GetChapterAhadithsCubit extends Cubit<GetChapterAhadithsState> {
  final ChapterAhadithsRepo _chapterAhadithsRepo;
  GetChapterAhadithsCubit(this._chapterAhadithsRepo)
    : super(GetChapterAhadithsInitial());
  late LocalHadithResponse localHadithResponse;

  Future<void> emitChapterAhadiths({
    required String bookSlug,
    required int chapterId,
    required bool hadithLocal,
  }) async {
    if (hadithLocal) {
      final result = await _chapterAhadithsRepo.getAhadith(
        bookSlug: bookSlug,
        chapterId: chapterId,
      );
      result.fold(
        (l) => emit(GetChapterAhadithsFailure(l.apiErrorModel.msg!)),
        (r) => emit(GetChapterAhadithsSuccess(r)),
      );
    } else {
      final result = await _chapterAhadithsRepo.getLocalAhadith(
        bookSlug: bookSlug,
        chapterId: chapterId,
      );
      result.fold(
        (l) => emit(GetChapterAhadithsFailure(l.apiErrorModel.msg!)),
        (r) => emit(GetLocalChapterAhadithsSuccess(r)),
      );
    }
  }
}
