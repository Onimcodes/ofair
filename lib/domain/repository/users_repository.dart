

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ofair/domain/model/ride_request_models.dart';
import 'package:ofair/domain/model/user_model.dart';

abstract class UsersRepository {
     Future<List<UserModel>> getUsers();
     Future<void> saveUserData(Map<String, dynamic> jsonResponse);
    Future<Map<String, dynamic>?> getUserData();
      Map<String, dynamic>? getCachedUserData() ;
      Future<List<RideRequestModel>> getRideRequests(String userId);

     Future<Response> createRideRequest({
    required String userId,
    required String rideTag,
    required File rideInfoImage,
  });
    
}