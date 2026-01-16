

import 'package:ofair/domain/model/user_chat_models.dart';

enum ChatHistoryStatus
 {initial, loading, success, error}

class ChatHistoryState {
  final ChatHistoryStatus
   status;
  final String? errorMessage;
 final List<ChatHistoryMessage>? chatHistory;

  ChatHistoryState._({
    required this.status,
    this.errorMessage,
    this.chatHistory,
  });

  factory ChatHistoryState.initial() =>  ChatHistoryState._(status : ChatHistoryStatus
  .initial);
  
  ChatHistoryState copyWith({ChatHistoryStatus
  ? status, String? errorMessage, List<ChatHistoryMessage>? chatHistory}){
    return ChatHistoryState._(
      status:  status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      chatHistory: chatHistory ?? this.chatHistory
      );
  }
}