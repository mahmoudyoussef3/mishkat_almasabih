import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mishkat_almasabih/features/navigation/data/models/navigation_hadith_model.dart';
import 'package:mishkat_almasabih/features/navigation/data/repos/navigation_repo.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  final NavigationRepo _navigationRepo;
  NavigationCubit(this._navigationRepo) : super(NavigationInitial());

  Future<void> emitNavigationStates(
    String hadithNumber,
    String bookSlug,
    String chapterNumber,
  ) async {
    final result = await _navigationRepo.navigationHadith(
      hadithNumber,
      bookSlug,
      chapterNumber,
    );

    result.fold(
      (l) => emit(
        NavigationFailure(l.apiErrorModel.msg ?? 'حدث خطأ حاول مرة أخري'),
      ),
      (r) => emit(NavigationSuccess(r)),
    );
  }
}
