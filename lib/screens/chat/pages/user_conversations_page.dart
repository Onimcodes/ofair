import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ofair/common/dependency_injection.dart';
import 'package:ofair/presentation/chat_bloc/chat_bloc.dart';
import 'package:ofair/presentation/chat_bloc/chat_event.dart';
import 'package:ofair/presentation/chat_bloc/chat_state.dart';
import 'package:ofair/screens/chat/pages/chat_detail_page.dart';

class UserConversationsPage extends StatefulWidget {
  final String token;
  final String userId;

  const UserConversationsPage({
    super.key,
    required this.token,
    required this.userId,
  });

  @override
  State<UserConversationsPage> createState() =>
      _UserConversationsPageState();
}

class _UserConversationsPageState extends State<UserConversationsPage> {
  late final ChatBloc chatBloc;

  @override
  void initState() {
    super.initState();

    chatBloc = getit<ChatBloc>();

    chatBloc.add(GetUserConversationEvent(
      userId: widget.userId,
      token: widget.token,
    ));

    chatBloc.add(ConnectToSignalREvent(
      token: widget.token,
      userId: widget.userId,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: chatBloc,
      child: Scaffold(
        appBar: AppBar(title: const Text('Conversations')),
        body: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            if (state.status == ChatStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == ChatStatus.success) {
              final convs = state.conversations ?? [];

              if (convs.isEmpty) {
                return const Center(child: Text('No conversations'));
              }

              return ListView.separated(
                itemCount: convs.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final c = convs[index];
                  return ListTile(
                                  leading: CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(c.userImage),
                    ),
                    title: Text(c.userName),
                    subtitle: Text(c.lastMessage),
                    onTap: () async {
                      final shouldRefresh = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatDetailPage(
                            conversationId: c.id,
                            userName: c.userName,
                            userImage: c.userImage,
                          ),
                        ),
                      );

                      if (shouldRefresh == true) {
                        chatBloc.add(
                          GetUserConversationEvent(
                            userId: widget.userId,
                            token: widget.token,
                          ),
                        );
                      }
                    },

                  );
                },
              
              );
            }

            return const Center(child: Text('Something went wrong'));
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    // chatBloc.close();
    super.dispose();
  }
}
