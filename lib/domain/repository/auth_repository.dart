import 'package:ofair/domain/model/onboarding_models.dart';

abstract class AuthRepository {
  Future<bool> register(RegisterRequestModel request);

  Future<bool> login(LoginRequestModel request);
}