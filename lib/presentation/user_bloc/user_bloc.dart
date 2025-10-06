// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ofair/domain/repository/users_repository.dart';
// import 'package:ofair/presentation/bloc/users_state.dart';
// import 'package:ofair/presentation/user_bloc/user_event.dart';
// import 'package:ofair/presentation/user_bloc/user_state.dart' hide UserState;

// class UserBloc extends Bloc<UserEvent, UserState> {
//   final UsersRepository usersRepository;

//   UserBloc({required this.usersRepository}) : super(UserInitial()) {
//     on<LoadUserData>(_onLoadUserData);
//     on<RefreshUserData>(_onRefreshUserData);
//   }

//   Future<void> _onLoadUserData(
//     LoadUserData event,
//     Emitter<UserState> emit,
//   ) async {
//     emit(UserLoading());
//     try {
//       final userData = await usersRepository.getUserData();
//       if (userData != null) {
//         emit(UserLoaded(userData));
//       } else {
//         emit(UserError('No user data available'));
//       }
//     } catch (e) {
//       emit(UserError('Failed to load user data: ${e.toString()}'));
//     }
//   }

//   Future<void> _onRefreshUserData(
//     RefreshUserData event,
//     Emitter<UserState> emit,
//   ) async {
//     try {
//       final userData = await usersRepository.getUserData();
//       if (userData != null) {
//         emit(UserLoaded(userData));
//       } else {
//         emit(UserError('No user data available'));
//       }
//     } catch (e) {
//       emit(UserError('Failed to refresh user data: ${e.toString()}'));
//     }
//   }
// }
