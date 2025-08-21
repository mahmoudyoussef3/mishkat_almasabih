import 'package:dartz/dartz.dart';
import 'package:mishkat_almasabih/core/networking/api_service.dart';
import 'package:mishkat_almasabih/features/authentication/login/data/models/login_response_body.dart';

import '../../../../../core/networking/api_error_handler.dart';
import '../models/login_request_body.dart';

class LoginRepo {
  final ApiService _apiService;

  LoginRepo(this._apiService);

  Future<Either<ErrorHandler, LoginResponseBody>> login(
    LoginRequestBody loginRequestBody,
  ) async {
    try {
      final response = await _apiService.login(loginRequestBody);
      return Right(response); // success case
    } catch (error) {
      return Left(ErrorHandler.handle(error)); // failure case
    }
  }

  /*
  Future<User?> signInWithGoogle() async {
    try {
      // Start Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // user canceled

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Get credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase
      final userCredential = await _auth.signInWithCredential(credential);

      // Save token in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", googleAuth.idToken ?? "");

      return userCredential.user;
    } catch (e) {
      print("Google Sign-In Error: $e");
      return null;
    }
  }
  */

  /// Load token later

}
