import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mishkat_almasabih/features/hadith_analysis/data/models/hadith_analysis_request.dart';
import 'package:mishkat_almasabih/features/hadith_analysis/data/models/hadith_analysis_response.dart';
import 'package:mishkat_almasabih/features/hadith_analysis/data/repos/hadith_analysis_repo.dart';

part 'hadith_analysis_state.dart';

class HadithAnalysisCubit extends Cubit<HadithAnalysisState> {
  final HadithAnalysisRepo repo;
  HadithAnalysisCubit(this.repo) : super(HadithAnalysisInitial());
  Future<void> analyzeHadith({
   required String hadith,
    required String attribution,
   required String grade,
   required String reference,
  }) async {
    emit(HadithAnalysisLoading());
    final result = await repo.analyzeHadith(
      HadithAnalysisRequest(
        hadeeth: hadith,
        attribution: attribution,
        grade: grade,
        reference: reference,
      ),
    );
    result.fold(
      (error) => emit(
        HadithAnalysisError(
          error.apiErrorModel.msg ?? "حدث خطأ ما. حاول مرة أخرى",
        ),
      ),
      (response) => emit(HadithAnalysisLoaded(response)),
    );
  }
}
