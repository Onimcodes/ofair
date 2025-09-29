
import 'package:ofair/data/datasource/user_remote_datasource.dart';
import 'package:ofair/domain/model/user_model.dart';
import 'package:ofair/domain/repository/users_repository.dart';

class UsersRepositoryImpl implements UsersRepository{
    final UserRemoteDatasource userRemoteDatasource;

    UsersRepositoryImpl({required this.userRemoteDatasource});
    

    @override
  Future<List<UserModel>> getUsers() async {
     return await userRemoteDatasource.getUsers();
  }



}