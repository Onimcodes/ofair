import 'package:ofair/domain/model/user_chat_models.dart';

abstract class ChatHistoryEvent {}


class GetChatHistoryEvent extends ChatHistoryEvent {
  final String token;
  final String userId;
  final String selectedUserId;

  GetChatHistoryEvent({required this.userId, required this.token, required this.selectedUserId});
}


class SendMessageEvent extends ChatHistoryEvent  {
  final String senderId;
  final String receiverId;
  final String message;
  final String token;

  SendMessageEvent({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.token
  });
}


class OnMessageReceivedEvent extends ChatHistoryEvent {
  final ChatHistoryMessage message;

  OnMessageReceivedEvent({required this.message});
}


