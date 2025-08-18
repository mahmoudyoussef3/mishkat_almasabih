import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mishkat_almasabih/features/get_book_chapters/data/models/book_chapters_model.dart';
import 'package:mishkat_almasabih/features/get_book_chapters/data/repos/book_chapters_repo.dart';

part 'get_book_chapters_state.dart';

class GetBookChaptersCubit extends Cubit<GetBookChaptersState> {
  final BookChaptersRepo _bookChaptersRepo;
  GetBookChaptersCubit(this._bookChaptersRepo)
    : super(GetBookChaptersInitial());

  Future<void> emitGetBookChapters(String bookSlug) async {
    emit(GetBookChaptersLoading());
    final result = await _bookChaptersRepo.getBookChapters(bookSlug);
    result.fold(
      (l) => emit(GetBookChaptersFailure(l.apiErrorModel.msg)),
     (r) =>  emit(GetBookChaptersSuccess(r)),
    );
  }
}
