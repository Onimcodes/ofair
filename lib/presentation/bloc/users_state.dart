import 'package:ofair/domain/model/user_model.dart';

enum UserStatus {initial, loading, success, error}

class UserState {
  final UserStatus status;
  final String? errorMessage;

  final List<UserModel>? users;

  UserState._({
    required this.status,
    this.errorMessage,
    this.users,   
  });

  factory UserState.initial() =>  UserState._(status : UserStatus.initial);
  
  UserState copyWith({UserStatus? status, String? errorMessage, List<UserModel>? users}){
    return UserState._(
      status:  status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      users: users ?? this.users
      );
  }
}