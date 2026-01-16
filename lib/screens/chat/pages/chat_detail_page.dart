import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ofair/common/dependency_injection.dart';
import 'package:ofair/domain/repository/users_repository.dart';
import 'package:ofair/presentation/bloc/chat_history_bloc/chat_history_bloc.dart';
import 'package:ofair/presentation/bloc/chat_history_bloc/chat_history_event.dart';
import 'package:ofair/presentation/bloc/chat_history_bloc/chat_history_state.dart';


class ChatDetailPage extends StatefulWidget {
  final String conversationId;
  final String userName;
  final String userImage;

  const ChatDetailPage({
    super.key,
    required this.conversationId,
    required this.userName,
    required this.userImage,
  });

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
  

  
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();
   late final ScrollController _scrollController;


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
  late final ChatHistoryBloc chatBloc;


  
void _sendMessage() {
  final text = _messageController.text.trim();
  if (text.isEmpty) return;

  chatBloc.add(
    SendMessageEvent(
      receiverId: widget.conversationId,
      senderId: _userId,
      message: text,
      token: _token ??''
    ),
  );

  _messageController.clear();
}
 @override
 void initState() {
    // TODO: implement initState
    super.initState();
     _scrollController = ScrollController();
   /// Load chat history
   /// 
    chatBloc = getit<ChatHistoryBloc>();

    chatBloc.add(GetChatHistoryEvent(
      userId: _userId ,
      token: _token ?? '',
      selectedUserId: widget.conversationId
    ));

    // context.read<ChatBloc>().add(
    //       GetChatHistoryEvent(
    //         token: _token ?? '',
    //         selectedUserId: widget.conversationId, 
    //         userId: _userId// ✅ CORRECT
    //       ),
    //     );


  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: chatBloc,
      child: PopScope(
        canPop:false ,
        onPopInvoked: (didpop) {
          if (didpop) return ;
            //   send result back
           Navigator.pop(context, true);
        },
        child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.userImage),
              ),
              const SizedBox(width: 10),
              Text(widget.userName),
            ],
          ),
        ),
            body: Column(
          children: [
            /// ✅ MESSAGE LIST
            Expanded(
        child: BlocBuilder<ChatHistoryBloc, ChatHistoryState>(
          builder: (context, state) {
            final messages = state.chatHistory;
        
            if (messages != null && messages.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_scrollController.hasClients) {
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                );
              }
            });
          }
            if (state.status == ChatHistoryStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
        
          
            if (messages == null || messages.isEmpty) {
              return const Center(child: Text('No messages yet'));
            }
        
            return ListView.builder(
              controller:_scrollController ,
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isMe = msg.isCurrentUserSentMessage;
        
                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe
                          ? Colors.blue.shade100
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(msg.text),
                        if (msg.isPending) ...[
                          const SizedBox(width: 6),
                          const SizedBox(
                            width: 10,
                            height: 10,
                            child: CircularProgressIndicator(strokeWidth: 1),
                          ),
                        ],
                      ],
                    ),
        
                  ),
                );
              },
            );
          },
        ),
            ),
        
            /// ✅ INPUT BOX
            Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: _sendMessage,
            ),
          ],
        ),
            ),
          ],
        ),
        
        
            ),
      ),
    );


  }


  
      @override
      void dispose() {
          _scrollController.dispose();
        // chatBloc.close();
        super.dispose();
      }
}
