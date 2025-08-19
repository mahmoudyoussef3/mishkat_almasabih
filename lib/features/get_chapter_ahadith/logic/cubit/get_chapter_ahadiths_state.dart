part of 'get_chapter_ahadiths_cubit.dart';

@immutable
sealed class GetChapterAhadithsState {}

final class GetChapterAhadithsInitial extends GetChapterAhadithsState {}

final class GetChapterAhadithsLoading extends GetChapterAhadithsState {}

final class GetChapterAhadithsSuccess extends GetChapterAhadithsState {
  final HadithResponse hadithResponse;
  GetChapterAhadithsSuccess(this.hadithResponse);
}

final class GetChapterAhadithsFailure extends GetChapterAhadithsState {
  final String error;
  GetChapterAhadithsFailure(this.error);
}
