import 'package:ofair/data/datasource/ofair_remote_datasource.dart';
import 'package:ofair/domain/model/onboarding_models.dart';
import 'package:ofair/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final OfairRemoteDatasource ofairRemoteDatasource;

  AuthRepositoryImpl({required this.ofairRemoteDatasource});

  @override
  Future<bool> register(RegisterRequestModel request) async {
    return await ofairRemoteDatasource.register(request);
  }

  @override
  Future<bool> login(LoginRequestModel request) async {
    return await ofairRemoteDatasource.login(request);
  }
}
