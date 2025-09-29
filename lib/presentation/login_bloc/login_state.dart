import 'package:ofair/domain/model/user_model.dart';

enum LoginStatus {initial, loading, success, error}

class LoginState {
  final LoginStatus status;
  final String? errorMessage;

  final bool isSucess;

  LoginState._({
    required this.status,
    this.errorMessage,
    required this.isSucess,
  });

  factory LoginState.initial() =>  LoginState._(status : LoginStatus.initial, isSucess: false);
  
  LoginState copyWith({LoginStatus? status, String? errorMessage, bool? isSuccess}){
    return LoginState._(
      status:  status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isSucess: isSuccess ?? this.isSucess
      );
  }
}