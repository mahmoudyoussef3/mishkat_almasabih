import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:mishkat_almasabih/features/remaining_questions/data/models/remaining_questions_response_model.dart';
import 'package:mishkat_almasabih/features/remaining_questions/data/repos/remaining_questions_repo.dart';

part 'remaining_questions_state.dart';

class RemainingQuestionsCubit extends Cubit<RemainingQuestionsState> {
  final RemainingQuestionsRepo _remainingQuestionsRepo;
  RemainingQuestionsCubit(this._remainingQuestionsRepo)
    : super(RemainingQuestionsInitial());

  int remaining = 0;

  Future<void> emitRemainingQuestions() async {
    emit(RemainingQuestionsLoading());
    final result = await _remainingQuestionsRepo.getRemainingQuestions();

    result.fold(
      (l) => emit(
        RemainingQuestionsFailure(
          l.apiErrorModel.msg ?? "حدث خطأ. حاول مرة أخري",
        ),
      ),
      (r) {
        remaining = r.remaining!;
        emit(RemainingQuestionsSuccess(r));
        
      },
    );
  }
}
