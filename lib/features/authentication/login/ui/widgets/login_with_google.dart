import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mishkat_almasabih/core/networking/dio_factory.dart';
import 'package:mishkat_almasabih/core/theming/colors.dart';

class LoginWithGoogle extends StatelessWidget {
  const LoginWithGoogle({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        

final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: ['email', 'profile'],
  clientId: "479373165372-kfm8ch3rt17kod1qk0uva7g9b7e39ue1.apps.googleusercontent.com",
);

  try {
    final GoogleSignInAccount? account = await _googleSignIn.signIn();
    if (account != null) {
      final GoogleSignInAuthentication auth = await account.authentication;

      // ده التوكين اللي تبعته للباك إند
      final idToken = auth.idToken;
final Dio dio = Dio(
  BaseOptions(
    baseUrl: "https://api.hadith-shareef.com/api/", // غير ده لعنوان السيرفر بتاعك
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ),
);
      // ابعته للـ backend API بتاعك
          final response = await dio.post(
      "/auth/google", // Endpoint عندك في السيرفر
      data: {"id_token": idToken},
    );

      print("Backend response: ${response.data}");
    }
  } catch (error) {
    print("Google Sign-In Error: $error");
  }

      },
      child: Card(
        color: Colors.white,
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              //  border: Border.all(color: ColorsManager.primaryGreen),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
      
                children: [
                  Text(
                    'تسجيل الدخول عبر جوجل',
                    style: TextStyle(color: ColorsManager.darkGray),
                  ),
                  Icon(Icons.apple, color: ColorsManager.darkGray),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
