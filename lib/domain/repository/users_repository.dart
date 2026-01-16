

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ofair/domain/model/ride_request_models.dart';
import 'package:ofair/domain/model/user_chat_models.dart';
import 'package:ofair/domain/model/user_model.dart';

abstract class UsersRepository {
     Future<List<UserModel>> getUsers();
     Future<void> saveUserData(Map<String, dynamic> jsonResponse);
    Future<Map<String, dynamic>?> getUserData();
      Map<String, dynamic>? getCachedUserData() ;
      Future<List<RideRequestModel>> getRideRequests(String userId);
    Future<List<UserConversationModel>> getUserConversations(String userId, String token);
    Future<List<ChatHistoryMessage>> getChatHistory({
      required String currentUserId,
      required String receiverUserId,
      required String token,
    });

     Future<Response> createRideRequest({
    required String userId,
    required String rideTag,
    required File rideInfoImage,
  });
    
}