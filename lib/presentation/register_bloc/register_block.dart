import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ofair/domain/model/onboarding_models.dart';
import 'package:ofair/domain/repository/auth_repository.dart';

import 'package:ofair/presentation/register_bloc/register_event.dart';
import 'package:ofair/presentation/register_bloc/register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository authRepository;

  RegisterBloc({required this.authRepository}) : super(RegisterState.initial()){
    on<RegisterUserEvent>(onRegisterUserEvent);
  }


  Future onRegisterUserEvent(RegisterUserEvent event, Emitter emit) async  {
  emit(state.copyWith(status: RegisterStatus.loading, email: event.email));
  try {
       
    var result = await authRepository.register(RegisterRequestModel(email: event.email, password: event.password));
      if(result != true) {
      emit (state.copyWith(status:RegisterStatus.error, isSuccess: result, email: event.email));
    }else {
    emit(state.copyWith(status: RegisterStatus.success, isSuccess : result, email: event.email));

    }
  } catch (e) {
    emit(state.copyWith(status : RegisterStatus.error, errorMessage: e.toString()));
  }
}

}
