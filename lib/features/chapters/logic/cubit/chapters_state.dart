part of 'chapters_cubit.dart';

@immutable
sealed class ChaptersState {}

final class ChaptersInitial extends ChaptersState {}

final class ChaptersLoading extends ChaptersState {}

final class ChaptersSuccess extends ChaptersState {
  final ChaptersModel bookChaptersModel;
  ChaptersSuccess(this.bookChaptersModel);
}

final class ChaptersFailure extends ChaptersState {
  final String? errorMessage;
  ChaptersFailure(this.errorMessage);
}
