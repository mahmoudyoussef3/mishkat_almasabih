import 'package:dio/dio.dart';
import 'package:mishkat_almasabih/features/authentication/login/data/models/login_response_body.dart';
import 'package:mishkat_almasabih/features/authentication/signup/data/models/sign_up_request_body.dart';
import 'package:mishkat_almasabih/features/authentication/signup/data/models/sign_up_response_body.dart';
import 'package:retrofit/retrofit.dart';

import '../../features/authentication/login/data/models/login_request_body.dart';
import 'api_constants.dart';
part 'api_service.g.dart';


@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST(ApiConstants.login)
  Future<LoginResponseBody> login(
      @Body() LoginRequestBody loginRequestBody,
      );

  @POST(ApiConstants.signup)
  Future<SignUpResponseBody> signup(
      @Body() SignupRequestBody signupRequestBody,
      );

}