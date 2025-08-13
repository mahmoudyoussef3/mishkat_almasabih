import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../networking/api_service.dart';
import '../networking/dio_factory.dart';
import '../../features/authentication/login/data/repo/login_repo.dart';
import '../../features/authentication/login/logic/cubit/login_cubit.dart';

final getIt = GetIt.instance;

Future<void> setUpGetIt() async {
  Dio dio = await DioFactory.getDio();

  getIt.registerLazySingleton<ApiService>(() => ApiService(dio));

  getIt.registerLazySingleton<LoginRepo>(() => LoginRepo(getIt()));
  getIt.registerLazySingleton<LoginCubit>(() => LoginCubit(getIt()));
}
