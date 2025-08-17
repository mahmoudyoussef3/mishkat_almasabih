import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:mishkat_almasabih/core/networking/api_error_handler.dart';
import 'package:mishkat_almasabih/core/networking/api_service.dart';
import 'package:mishkat_almasabih/features/book_data/data/models/book_data_model.dart';

class GetBookDataRepo {
  final ApiService _apiService;

  GetBookDataRepo(this._apiService);

  Future<Either<ErrorHandler, CategoryResponse>>
  getBookData(String id) async {
    try {
      final response = await _apiService.getBookData(id);
      return Right(response);
    } catch (error) {
                                  log(error.toString());

      return Left(ErrorHandler.handle(error));
    }
  }
}
