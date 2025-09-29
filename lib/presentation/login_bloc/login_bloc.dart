import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ofair/domain/model/onboarding_models.dart';
import 'package:ofair/domain/repository/auth_repository.dart';
import 'package:ofair/presentation/login_bloc/login_event.dart';
import 'package:ofair/presentation/login_bloc/login_state.dart';

import 'package:ofair/presentation/register_bloc/register_event.dart';
import 'package:ofair/presentation/register_bloc/register_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc({required this.authRepository}) : super(LoginState.initial()){
    on<LoginUserEvent>(onLoginUserEvent);
  }


  Future onLoginUserEvent(LoginUserEvent event, Emitter emit) async  {
  emit(state.copyWith(status: LoginStatus.loading));
  try {
       
    var result = await authRepository.login(LoginRequestModel(email: event.email, password: event.password));
    emit(state.copyWith(status: LoginStatus.success, isSuccess : result));
  } catch (e) {
    emit(state.copyWith(status : LoginStatus.error, errorMessage: e.toString()));
  }
}

}