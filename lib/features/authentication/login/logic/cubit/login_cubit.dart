import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat_almasabih/features/authentication/login/data/models/login_request_body.dart';
import 'package:mishkat_almasabih/features/authentication/login/data/repo/login_repo.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo _loginRepo;

  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginCubit( this._loginRepo) : super( LoginInitial());

  Future<void> emitLoginStates() async {
    emit(LoginLoading());
    final response = await _loginRepo.login(
      LoginRequestBody(
        email: emailController.text,
        password: passwordController.text,
      ),
    );

    response.fold(
      (error) => emit(LoginError(error.apiErrorModel.msg.toString())),
      (data) => emit(LoginSuccess()),
    );
  }
  /*
  Future<void> saveUserToken(String token) async {
    await SharedPrefHelper.setSecuredString(SharedPrefKeys.userToken, token);
    DioFactory.setTokenIntoHeaderAfterLogin(token);
  }
  */
}
