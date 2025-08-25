part of 'chapters_cubit.dart';

@immutable
sealed class ChaptersState {}

final class ChaptersInitial extends ChaptersState {}

final class ChaptersLoading extends ChaptersState {}

final class ChaptersSuccess extends ChaptersState {
  final List<Chapter> allChapters;
  final List<Chapter> filteredChapters;
  ChaptersSuccess({required this.allChapters, required this.filteredChapters});

  ChaptersSuccess copyWith({
    List<Chapter>? allChapters,
    List<Chapter>? filteredChapters,
  }) {
    return ChaptersSuccess(
      allChapters: allChapters ?? this.allChapters,
      filteredChapters: filteredChapters ?? this.filteredChapters,
    );
  }
}

final class ChaptersFailure extends ChaptersState {
  final String? errorMessage;
  ChaptersFailure(this.errorMessage);
}
