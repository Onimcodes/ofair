import 'package:ofair/domain/model/user_model.dart';

enum RegisterStatus {initial, loading, success, error}

class RegisterState {
  final RegisterStatus status;
  final String? errorMessage;

  final bool isSucess;

  RegisterState._({
    required this.status,
    this.errorMessage,
    required this.isSucess,
  });

  factory RegisterState.initial() =>  RegisterState._(status : RegisterStatus.initial, isSucess: false);
  
  RegisterState copyWith({RegisterStatus? status, String? errorMessage, bool? isSuccess}){
    return RegisterState._(
      status:  status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      isSucess: isSuccess ?? this.isSucess
      );
  }
}