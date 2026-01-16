

  import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ofair/common/signalr_service/signalr_service.dart';
import 'package:ofair/domain/model/user_chat_models.dart';
import 'package:ofair/domain/repository/users_repository.dart';
import 'package:ofair/presentation/chat_bloc/chat_event.dart';
import 'package:ofair/presentation/chat_bloc/chat_state.dart';


class ChatBloc extends Bloc<ChatEvent, ChatState> {
final UsersRepository usersRepository;
final SignalRService signalService;


  ChatBloc({required this.usersRepository, required this.signalService}) : super(ChatState.initial()){
    on<GetUserConversationEvent>(getConversationsEvent);
    on<ConnectToSignalREvent>(_onConnectToSignalR);
    on<NewMessageReceivedEvent>(_onNewMessageReceived);
        // on<ConversationUpdatedEvent>(_onConversationUpdated);
    on<DisconnectSignalREvent>(_onDisconnectSignalR);
  }

   
  Future getConversationsEvent(GetUserConversationEvent event, Emitter emit) async  {
      emit(state.copyWith(status: ChatStatus.loading));
    try {
         print('fetching conversations');
          var result = await usersRepository.getUserConversations(event.userId, event.token);
          emit(
            state.copyWith(
              status: ChatStatus.success,
              conversations : result
            ),
          );
        } catch (e) {
          emit(
            state.copyWith(
              status: ChatStatus.error,
              errorMessage: e.toString(),
            ),
          );
        }
    }


     Future<void> _onConnectToSignalR(
        ConnectToSignalREvent event,
        Emitter<ChatState> emit,
      ) async {
        try {
          await signalService.connect(event.token);
          // await signalService.joinUserConversations(event.userId);

          // Listen for new messages
          signalService.onNewMessage((conversationId, message, date, time) {
            add(NewMessageReceivedEvent(
              conversationId: conversationId,
              message: message,
            ));
          });

          // Listen for conversation updates
          signalService.onConversationUpdated((conversationData) {
            add(ConversationUpdatedEvent(conversationData: conversationData));
          });
        } catch (e) {
          print('SignalR connection error: $e');
        }
      }

  void _onNewMessageReceived(
    NewMessageReceivedEvent event,
    Emitter<ChatState> emit,
  ) {
    final conversations = List<UserConversationModel>.from(
      state.conversations ?? [],
    );

    final index =
        conversations.indexWhere((c) => c.id == event.conversationId);

    if (index != -1) {
      conversations[index] = conversations[index].copyWith(
        lastMessage: event.message,
        updatedAt: DateTime.now(), // 🔥 REQUIRED
      );
    }

    conversations.sort(
      (a, b) => b.updatedAt.compareTo(a.updatedAt),
    );  

    emit(state.copyWith(conversations: conversations));
  }

        // void _onConversationUpdated(
        //   ConversationUpdatedEvent event,
        //   Emitter<ChatState> emit,
        // ) {
        //   // Parse the updated conversation
        //   final updatedConv = Conversation.fromJson(event.conversationData);
          
        //   final conversations = List<Conversation>.from(state.conversations ?? []);
        //   final index = conversations.indexWhere((c) => c.id == updatedConv.id);
          
        //   if (index != -1) {
        //     conversations[index] = updatedConv;
        //   } else {
        //     conversations.insert(0, updatedConv);
        //   }

        //   conversations.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        //   emit(state.copyWith(conversations: conversations));
        // }

        Future<void> _onDisconnectSignalR(
          DisconnectSignalREvent event,
          Emitter<ChatState> emit,
        ) async {
          await signalService.disconnect();
        }

        @override
        Future<void> close() {
          signalService.disconnect();
          return super.close();
        } 
      }
