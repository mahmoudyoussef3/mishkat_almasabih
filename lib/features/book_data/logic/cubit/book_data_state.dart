part of 'book_data_cubit.dart';

@immutable
sealed class BookDataState {}

final class BookDataInitial extends BookDataState {}

final class BookDataLoading extends BookDataState {}

final class BookDataSuccess extends BookDataState {
  final CategoryResponse categoryResponse;
  BookDataSuccess(this.categoryResponse);
}

final class BookDataFailure extends BookDataState {
  String errorMessage;
  BookDataFailure(this.errorMessage);
}
