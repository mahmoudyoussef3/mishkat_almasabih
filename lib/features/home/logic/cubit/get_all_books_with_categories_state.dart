part of 'get_all_books_with_categories_cubit.dart';

@immutable
sealed class GetAllBooksWithCategoriesState {}

final class GetAllBooksWithCategoriesInitial
    extends GetAllBooksWithCategoriesState {}

final class GetAllBooksWithCategoriesSuccess
    extends GetAllBooksWithCategoriesState {
  BooksResponse booksResponse;
  GetAllBooksWithCategoriesSuccess(this.booksResponse);
}

final class GetAllBooksWithCategoriesLoading
    extends GetAllBooksWithCategoriesState {}

final class GetAllBooksWithCategoriesError
    extends GetAllBooksWithCategoriesState {
  final String errorMessage;
  GetAllBooksWithCategoriesError(this.errorMessage);
}
