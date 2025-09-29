import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ofair/domain/repository/users_repository.dart';
import 'package:ofair/presentation/bloc/users_event.dart';
import 'package:ofair/presentation/bloc/users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UserState> {
  final UsersRepository usersRepository;

  UsersBloc({required this.usersRepository}) : super(UserState.initial()){
    on<GetUsersEvent>(onGetUsersEvent);
  }


  Future onGetUsersEvent(GetUsersEvent event, Emitter emit) async  {
  emit(state.copyWith(status: UserStatus.loading));
  try {
    var result = await usersRepository.getUsers();
    emit(state.copyWith(status: UserStatus.success, users : result));
  } catch (e) {
    emit(state.copyWith(status : UserStatus.error, errorMessage: e.toString()));
  }
}

}


