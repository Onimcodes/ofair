

import 'package:ofair/domain/model/user_chat_models.dart';

enum ChatStatus {initial, loading, success, error}

class ChatState {
  final ChatStatus status;
  final String? errorMessage;
 final List<UserConversationModel>? conversations;

  ChatState._({
    required this.status,
    this.errorMessage,
    this.conversations,
  });

  factory ChatState.initial() =>  ChatState._(status : ChatStatus.initial);
  
  ChatState copyWith({ChatStatus? status, String? errorMessage, List<UserConversationModel>? conversations}){
    return ChatState._(
      status:  status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      conversations: conversations ?? this.conversations
      );
  }
}