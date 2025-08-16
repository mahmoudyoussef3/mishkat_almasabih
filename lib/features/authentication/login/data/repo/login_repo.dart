import 'package:dartz/dartz.dart';
import 'package:mishkat_almasabih/core/networking/api_service.dart';
import 'package:mishkat_almasabih/features/authentication/login/data/models/login_response_body.dart';

import '../../../../../core/networking/api_error_handler.dart';
import '../models/login_request_body.dart';

class LoginRepo {
  final ApiService _apiService;

  LoginRepo(this._apiService);

  Future<Either<ErrorHandler, LoginResponseBody>> login(
      LoginRequestBody loginRequestBody) async {
    try {
      final response = await _apiService.login(loginRequestBody);
      return Right(response); // success case
    } catch (error) {
      return Left(ErrorHandler.handle(error)); // failure case
    }
  }
}
