import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mishkat_almasabih/features/ahadith/data/models/ahadiths_model.dart';
import 'package:mishkat_almasabih/features/ahadith/search/data/hadith_search_repo.dart';
import 'package:mishkat_almasabih/features/search/home_screen/data/models/public_search_model.dart';
import 'package:mishkat_almasabih/features/search/home_screen/data/repos/public_search_repo.dart';

part 'hadith_search_cubit_state.dart';

class HadithSearchCubitCubit extends Cubit<HadithSearchCubitState> {
  final HadithSearchRepo _hadithSearchRepo;

  HadithSearchCubitCubit(this._hadithSearchRepo) : super(HadithSearchCubitInitial());

  Future<void> emitHadithSearch(String query, String bookSlug, String chapterName) async {
    emit(HadithSearchLoading());
    final result = await _hadithSearchRepo.getHadithSearchRepo(query,bookSlug,chapterName);
    result.fold(
      (error) =>
          emit(HadithSearchFailure(error.apiErrorModel.msg ?? 'حدث خطأ')),
      (searchResult) => emit(HadithSearchSuccess(searchResult)),
    );
  }
}
