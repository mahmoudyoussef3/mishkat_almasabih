import 'package:dartz/dartz.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mishkat_almasabih/core/networking/api_error_handler.dart';
import 'package:mishkat_almasabih/core/networking/api_service.dart';
import 'package:mishkat_almasabih/features/authentication/login/data/models/login_request_body.dart';
import 'package:mishkat_almasabih/features/authentication/login/data/models/login_response_body.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRepo {
  final ApiService _apiService;

  LoginRepo(this._apiService);

  Future<Either<ErrorHandler, LoginResponseBody>> login(
    LoginRequestBody loginRequestBody,
  ) async {
    try {
      final response = await _apiService.login(loginRequestBody);
      return Right(response);
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }

  Future<Either<ErrorHandler, LoginResponseBody>> googleLogin() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(



        scopes: ['email', 'profile', 'openid'],
               serverClientId:
              "479373165372-d9vr3f1c1b2aodv4kjngi5ra1diug1v6.apps.googleusercontent.com",
      );
      
 await googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return Left(ErrorHandler.handle('UnKnown error happened.'));
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final idToken = googleAuth.idToken ?? "";

      // استدعاء API backend بالـ idToken
      final response = await _apiService.googleLogin({"token": idToken});

      // خزن التوكين اللي السيرفر رجعه مش بس idToken
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", response.token ?? "");

      return Right(response);
    } catch (error) {
      return Left(ErrorHandler.handle(error));
    }
  }
}
