import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ofair/data/datasource/ofair_remote_datasource.dart';
import 'package:ofair/data/datasource/user_remote_datasource.dart';
import 'package:ofair/domain/model/ride_request_models.dart';
import 'package:ofair/domain/model/user_model.dart';
import 'package:ofair/domain/repository/users_repository.dart';

class UsersRepositoryImpl implements UsersRepository {
  final UserRemoteDatasource userRemoteDatasource;
  final OfairRemoteDatasource ofairRemoteDatasource;

  UsersRepositoryImpl({required this.userRemoteDatasource, required this.ofairRemoteDatasource});

  @override
  Future<List<UserModel>> getUsers() async {
    return await userRemoteDatasource.getUsers();
  }
  @override
  Future<void> saveUserData (Map<String, dynamic> jsonResponse) async {
    return await ofairRemoteDatasource.saveUserData(jsonResponse);
  }
  
  @override
  Future<Map<String, dynamic>?> getUserData() async {
   return await ofairRemoteDatasource.getUserData();
  }
  @override
  Map<String, dynamic>? getCachedUserData() {
      return ofairRemoteDatasource.getCachedUserData();
  }
  @override
  Future<List<RideRequestModel>> getRideRequests(String userId) async  {
     return await  ofairRemoteDatasource.getRideRequests(userId);
  }
 @override
  Future<Response> createRideRequest({required String userId, required String rideTag,   required File rideInfoImage}) async {
  return await ofairRemoteDatasource.createRideRequest(userId: userId, rideTag: rideTag, rideInfoImage: rideInfoImage);
  }
}
