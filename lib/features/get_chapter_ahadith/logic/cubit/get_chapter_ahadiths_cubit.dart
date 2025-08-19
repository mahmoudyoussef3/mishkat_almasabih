import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mishkat_almasabih/features/get_chapter_ahadith/data/models/chapter_ahadiths_model.dart';
import 'package:mishkat_almasabih/features/get_chapter_ahadith/data/repos/chapter_ahadiths_repo.dart';

part 'get_chapter_ahadiths_state.dart';

class GetChapterAhadithsCubit extends Cubit<GetChapterAhadithsState> {
  final ChapterAhadithsRepo _chapterAhadithsRepo;
  GetChapterAhadithsCubit(this._chapterAhadithsRepo)
    : super(GetChapterAhadithsInitial());

  Future<void> emitChapterAhadiths({
    required String bookSlug,
    required int chapterId,
  }) async {
    final result = await _chapterAhadithsRepo.getAhadith(
      bookSlug: bookSlug,
      chapterId: chapterId,
    );
    result.fold(
      (l) => emit(GetChapterAhadithsFailure(l.apiErrorModel.msg!)),
      (r) => emit(GetChapterAhadithsSuccess(r)),
    );
  }
}
