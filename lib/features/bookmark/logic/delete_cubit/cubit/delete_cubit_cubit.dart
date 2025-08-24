import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mishkat_almasabih/features/bookmark/data/models/book_mark_response.dart';
import 'package:mishkat_almasabih/features/bookmark/data/repos/book_mark_repo.dart';
import 'package:mishkat_almasabih/features/bookmark/logic/get_cubit/user_bookmarks_cubit.dart';

part 'delete_cubit_state.dart';

class DeleteCubitCubit extends Cubit<DeleteCubitState> {
  final BookMarkRepo _bookMarkRepo;
  DeleteCubitCubit(this._bookMarkRepo) : super(DeleteCubitInitial());

  Future<void> delete(int id) async {
    emit(DeleteLoading());
    final result = await _bookMarkRepo.deleteBookMark(id);

    result.fold(
      (l) => emit(DeleteFaliure(l.apiErrorModel.msg.toString())),
      (r) => emit(DeleteSuccess(r)),
    );
  }
}
