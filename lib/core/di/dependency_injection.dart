import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:mishkat_almasabih/features/authentication/signup/data/repo/signup_repo.dart';
import 'package:mishkat_almasabih/features/authentication/signup/logic/signup_cubit.dart';
import '../../features/authentication/login/logic/cubit/login_cubit.dart';
import '../networking/api_service.dart';
import '../networking/dio_factory.dart';
import '../../features/authentication/login/data/repo/login_repo.dart';
import '../../features/authentication/login/logic/cubit/login_cubit.dart';

final getIt = GetIt.instance;

Future<void> setUpGetIt() async {
  Dio dio = await DioFactory.getDio();

  getIt.registerLazySingleton<ApiService>(() => ApiService(dio));

  getIt.registerLazySingleton<LoginRepo>(() => LoginRepo(getIt()));
  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt()));

  getIt.registerLazySingleton<SignupRepo>(() => SignupRepo(getIt()));
  getIt.registerFactory<SignupCubit>(() => SignupCubit(getIt()));
}
