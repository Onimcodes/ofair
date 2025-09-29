import 'package:dio/dio.dart';
import 'package:ofair/domain/model/user_model.dart';

class UserRemoteDatasource {
  final Dio dio;

  UserRemoteDatasource({required this.dio});
  


  Future<List<UserModel>> getUsers() async {
    var result  = await dio.get('users');
    return (result.data['users'] as List)
    .map((e) => UserModel.fromJson(e))
    .toList();
  }


  


}