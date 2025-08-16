import 'package:dartz/dartz.dart';
import 'package:mishkat_almasabih/core/networking/api_error_handler.dart';
import 'package:mishkat_almasabih/core/networking/api_service.dart';
import 'package:mishkat_almasabih/features/home/data/models/book_model.dart';

class GetAllBooksWithCategoriesRepo {
  final ApiService _apiService;

  GetAllBooksWithCategoriesRepo(this._apiService);

  Future<Either<ErrorHandler, BooksResponse>>
  getAllBooksWithCategoriesRepo() async {
    try {
      final response = await _apiService.getAllBooksWithCategories();
      return Right(response);
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }
}
