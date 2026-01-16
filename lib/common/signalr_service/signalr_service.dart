import 'package:signalr_netcore/signalr_client.dart';

class SignalRService {
  HubConnection? _hubConnection;
  final String baseUrl;
  
  SignalRService({required this.baseUrl});

  Future<void> connect(String token) async {
   _hubConnection = HubConnectionBuilder()
        .withUrl(
          '$baseUrl/chatHub',
          options: HttpConnectionOptions(
            accessTokenFactory: () async => token
          ),
        )
        .withAutomaticReconnect()
        .build();

    await _hubConnection?.start();
  }

void onNewMessage(
  Function(String senderId, String message, String date, String time) callback,
) {
  _hubConnection?.on('ReceiveMessage', (arguments) {
    if (arguments != null && arguments.length >= 4) {
      callback(
        arguments[0] as String,
        arguments[1] as String,
        arguments[2] as String,
        arguments[3] as String,
      );
      print('yay a new message message ${arguments[0]}');
    }
  });
}


  void onConversationUpdated(Function(Map<String, dynamic> conversation) callback) {
    _hubConnection?.on('ConversationUpdated', (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        final conversation = arguments[0] as Map<String, dynamic>;
        callback(conversation);
      }
    });
  }

  Future<void> joinUserConversations(String userId) async {
    await _hubConnection?.invoke('JoinUserConversations', args: [userId]);
  }

  Future<void> sendMessage(String senderId, String receiverId, String message) async {
     await _hubConnection?.invoke(
  'SendMessage',
  args: [
    {
      "senderId": senderId,
      "receiverId": receiverId,
      "message": message,
    }
  ],
);

  }

  Future<void> disconnect() async {
    await _hubConnection?.stop();
  }

  bool get isConnected => _hubConnection?.state == HubConnectionState.Connected;
}