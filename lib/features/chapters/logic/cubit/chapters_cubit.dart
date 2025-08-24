import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mishkat_almasabih/features/chapters/data/models/chapters_model.dart';
import 'package:mishkat_almasabih/features/chapters/data/repos/chapters_repo.dart';

part 'chapters_state.dart';

class ChaptersCubit extends Cubit<ChaptersState> {
  final BookChaptersRepo _bookChaptersRepo;
  ChaptersCubit(this._bookChaptersRepo) : super(ChaptersInitial());

  Future<void> emitGetBookChapters(String bookSlug) async {
    emit(ChaptersLoading());
    final result = await _bookChaptersRepo.getBookChapters(bookSlug);
    result.fold(
      (l) => emit(ChaptersFailure(l.apiErrorModel.msg)),
      (r) => emit(ChaptersSuccess(r)),
    );
  }
}
