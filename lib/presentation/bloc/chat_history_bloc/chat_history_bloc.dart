import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ofair/common/dependency_injection.dart';
import 'package:ofair/common/signalr_service/signalr_service.dart';
import 'package:ofair/domain/model/user_chat_models.dart';
import 'package:ofair/domain/repository/users_repository.dart';
import 'package:ofair/presentation/bloc/chat_history_bloc/chat_history_event.dart';
import 'package:ofair/presentation/bloc/chat_history_bloc/chat_history_state.dart';

class ChatHistoryBloc extends Bloc <ChatHistoryEvent,ChatHistoryState>{
final UsersRepository usersRepository;
final SignalRService signalService;


 Map<String, dynamic>? get _userData {
    try {
      final usersRepository = getit<UsersRepository>();
      return usersRepository.getCachedUserData();
    } catch (e) {
      debugPrint('Error loading user data: $e');
      return null;
    }
  }

  String get _userName {
    if (_userData == null) return 'Guest';
    return _userData!['name'] ?? 
           _userData!['username'] ??
           'There';
  }

  String get _userId {
    if (_userData == null) return 'Guest';
    return _userData!['userId'] ?? 
           'User';
  }

  String? get _profileImage => _userData?['profilePic'];

  String? get _token => _userData?['token'];

   ChatHistoryBloc({required this.usersRepository, required this.signalService}) : super(ChatHistoryState.initial()){
    on<GetChatHistoryEvent>(getChatHistory);
    on<SendMessageEvent>(sendMessage);
    on<OnMessageReceivedEvent>(_onNewMessageReceived);


        // on<ConversationUpdatedEvent>(_onConversationUpdated);
    // on<DisconnectSignalREvent>(_onDisconnectSignalR);

      signalService.onNewMessage((senderId, text, date, time) {
      add(
        OnMessageReceivedEvent(
          message: ChatHistoryMessage(
            id: DateTime.now().millisecondsSinceEpoch,
            text: text,
            date: date,
            time: time,
            isCurrentUserSentMessage: senderId != _userId ? false :true,
          ),
        ),
      );
    });

  }

   Future<void> sendMessage(
        SendMessageEvent event,
        Emitter<ChatHistoryState> emit,
      ) async {
       
       print('message reached here ${event}');
          final optimisticMessage = ChatHistoryMessage(
          id: generateTemporaryId(), // temp ID
          text: event.message,
          isCurrentUserSentMessage: true,
          date: DateTime.now().toString(),
          time: DateTime.now().millisecondsSinceEpoch.toString(),
          isPending: true,


        );

       print('message reached here too .....${event}');
              
        final updatedMessages = List<ChatHistoryMessage>.from(
          state.chatHistory ?? [],
        )..add(optimisticMessage);

       print('--- Messages after optimistic update ---');
        for (final msg in updatedMessages) {
          print(
            'id: ${msg.id}, '
            'text: ${msg.text}, '
            'pending: ${msg.isPending}, '
            'isMe: ${msg.isCurrentUserSentMessage}',
          );
        }
        print('----------------------------------------');

      
        emit(
          state.copyWith(
            chatHistory: updatedMessages,
            status: ChatHistoryStatus.success,
          ),
        );
       try {
          print('message got here $event');
          // await signalService.connect(event.);
          await signalService.sendMessage(event.senderId, event.receiverId, event.message);

          // // Listen for conversation updates
          // signalService.onConversationUpdated((conversationData) {
          //   add(ConversationUpdatedEvent(conversationData: conversationData));
          // });
       }
         catch (e) {
          // ❌ Sending failed → remove or mark failed
           print('send failed with message ${e}');
            final failedMessages = List<ChatHistoryMessage>.from(
              state.chatHistory ?? [],
            )..removeWhere((m) => m.id == optimisticMessage.id);

            emit(
              state.copyWith(chatHistory: failedMessages),
            );
        }
      }

    Future getChatHistory(GetChatHistoryEvent event, Emitter emit) async  {
      emit(state.copyWith(status: ChatHistoryStatus.loading));
    try {
          var result = await usersRepository.getChatHistory(currentUserId : event.userId, receiverUserId:event.selectedUserId, token: event.token);
          print('Rceived this stuff here $result');
          emit(
            state.copyWith(
              status: ChatHistoryStatus.success,
              chatHistory : result
            ),
          );
          print('Rceived this stuff here $result');
          
        
         

        } catch (e) {
          print('something sup  $e');

          emit(
            state.copyWith(
              status: ChatHistoryStatus.error,
              errorMessage: e.toString(),
            ),
          );
        }
    }


 void _onNewMessageReceived(
  OnMessageReceivedEvent event,
  Emitter<ChatHistoryState> emit,
) {
  final updatedMessages = List<ChatHistoryMessage>.from(
    state.chatHistory ?? [],
  );
   // Remove pending version if it exists


  updatedMessages.removeWhere(
    (m) =>
        m.isPending &&
        m.text == event.message.text &&
        m.isCurrentUserSentMessage,
  );

  updatedMessages.add(event.message); // ✅ APPEND

  emit(
    state.copyWith(
      chatHistory: updatedMessages,
      status: ChatHistoryStatus.success,
    ),
  );
}

int generateTemporaryId() {
  return -DateTime.now().millisecondsSinceEpoch;
}

}