abstract class ChatEvent {

}



class GetUserConversationEvent extends ChatEvent {
  
  final String token;
  final String userId;

  
  GetUserConversationEvent({required this.userId, required this.token});
  
  

} 


class ConnectToSignalREvent extends ChatEvent {
  final String token;
  final String userId;
  ConnectToSignalREvent({required this.token, required this.userId});
}


class NewMessageReceivedEvent extends ChatEvent {
  final String conversationId;
  final String message;
  NewMessageReceivedEvent({required this.conversationId, required this.message});
}



class ConversationUpdatedEvent extends ChatEvent {
  final Map<String, dynamic> conversationData;
  ConversationUpdatedEvent({required this.conversationData});
}

class DisconnectSignalREvent extends ChatEvent {}



