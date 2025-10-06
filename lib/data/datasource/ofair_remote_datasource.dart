import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ofair/domain/model/onboarding_models.dart';
import 'package:ofair/domain/model/ride_request_models.dart';
import 'package:ofair/domain/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfairRemoteDatasource {
  final Dio dio;
  final SharedPreferences prefs;

  OfairRemoteDatasource({required this.dio, required this.prefs});

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
          'password': request.password,
        }),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print('Response:${response.data}');
      print('Status Code: ${response.statusCode}');
      saveUserData(response.data);
      if (response.statusCode == 200) {
        print('This is the data ooooooo:${response.data}');
        return true;
      }
      return false;
    } catch (e) {
      print('Error : $e');
    }

    return false;
  }


  

  Future<List<RideRequestModel>> getRideRequests(String userId) async {
    var result = await dio.get('api/RideRequest/RideRequests?userId=${userId}');
    List<RideRequestModel> rideRequests = (result.data['data'] as List)
        .map((e) => RideRequestModel.fromJson(e))
        .toList();

    // Order by 'createdAt' descending
    rideRequests.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    if (result.statusCode == 200) {
      print('This is the data ooooooo:${result.data}');
    }
    return rideRequests;
  }

  Future<void> saveUserData(Map<String, dynamic> jsonResponse) async {
    String jsonString = jsonEncode(jsonResponse);
    await prefs.setString("user_data", jsonString);
  }

  Future<Map<String, dynamic>?> getUserData() async {
    String? jsonString = prefs.getString("user_data");
    if (jsonString != null) {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    }
    return null;
  }

  Map<String, dynamic>? getCachedUserData() {
    final userJson = prefs.getString('user_data');
    if (userJson == null) return null;
    return jsonDecode(userJson);
  }




  Future<Response> createRideRequest({
    required String userId,
    required String rideTag,
    required File rideInfoImage,
  }) async {
    try {


      print('the ride tag got here $rideTag' );

      // Create FormData for multipart/form-data
      FormData formData = FormData.fromMap({
        'RideInfoImg': await MultipartFile.fromFile(
          rideInfoImage.path,
          filename: rideInfoImage.path.split('/').last,
        ),
        'RideTag': await MultipartFile.fromString(rideTag)
      });

      // Make the POST request
      final response = await dio.post(
        '/api/RideRequest/RideRequests/$userId',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      return response;
    } on DioException catch (e) {
      // Handle Dio specific errors
      throw _handleError(e);
    }
  }



    String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please try again.';
      case DioExceptionType.badResponse:
        return 'Server error: ${error.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Request cancelled';
      case DioExceptionType.connectionError:
        return 'No internet connection';
      default:
        return 'Something went wrong: ${error.message}';
    }
  }
}

