import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ofair/domain/model/onboarding_models.dart';
import 'package:ofair/domain/model/user_model.dart';

class OfairRemoteDatasource {
  final Dio dio;

  OfairRemoteDatasource({required this.dio});

  Future<List<UserModel>> getUsers() async {
    var result = await dio.get('users');
    return (result.data['users'] as List)
        .map((e) => UserModel.fromJson(e))
        .toList();
  }

  Future<bool> register(RegisterRequestModel request) async {
    try {
      print('${request.toJson()}');
      var response = await dio.post(
        'api/Authentication/Register',
        data: jsonEncode({
          'email': request.email,
          'password': request.password,
          'userRole': 'User',
        }),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print('Response:${response.data}');
      print('Status Code: ${response.statusCode}');
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print('Error : $e');
    }

    return false;
  }


  Future<bool> login(LoginRequestModel request) async {
    try {
      print('${request.toJson()}');
      var response = await dio.post(
        'api/Authentication/Login',
        data: jsonEncode({
          'email': request.email,
          'password': request.password
        }),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print('Response:${response.data}');
      print('Status Code: ${response.statusCode}');
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print('Error : $e');
    }

    return false;
  }
}
