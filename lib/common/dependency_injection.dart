


import 'dart:developer';

import 'package:get_it/get_it.dart';
import 'package:ofair/common/api/api_client.dart';
import 'package:ofair/common/api/ofair_api_client.dart';
import 'package:ofair/data/datasource/ofair_remote_datasource.dart';
import 'package:ofair/data/datasource/user_remote_datasource.dart';
import 'package:ofair/data/repository/auth_repository_impl.dart';
import 'package:ofair/data/repository/users_repository_impl.dart';
import 'package:ofair/domain/repository/auth_repository.dart';
import 'package:ofair/domain/repository/users_repository.dart';
import 'package:ofair/presentation/bloc/users_bloc.dart';
import 'package:ofair/presentation/login_bloc/login_bloc.dart';
import 'package:ofair/presentation/register_bloc/register_block.dart';

var getit = GetIt.instance;


void setup() {
  getit.registerSingleton(ApiClient());
  getit.registerSingleton(OfairApiClient());
  getit.registerLazySingleton(() => UserRemoteDatasource(dio: getit<ApiClient>().getDio()));
  getit.registerLazySingleton(() => OfairRemoteDatasource(dio: getit<OfairApiClient>().getDio()));
  getit.registerLazySingleton<AuthRepository>(()
   => AuthRepositoryImpl(ofairRemoteDatasource: getit()));
  getit.registerLazySingleton<UsersRepository>(
    ()    => UsersRepositoryImpl(userRemoteDatasource: getit()),

  );


  getit.registerFactory(() => UsersBloc(usersRepository: getit()));
  getit.registerFactory(() => RegisterBloc(authRepository: getit()));
  getit.registerFactory(() => LoginBloc(authRepository: getit()));
  
}