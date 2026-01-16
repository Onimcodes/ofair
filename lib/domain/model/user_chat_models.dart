class UserConversationModel {
  final String id;
  final String userName;
  final String userImage;
  final String lastMessage;
  final DateTime updatedAt;

  UserConversationModel({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.lastMessage,
    required this.updatedAt,
  });

  UserConversationModel copyWith({
    String? id,
    String? userName,
    String? userImage,
    String? lastMessage,
    DateTime? updatedAt,
  }) {
    return UserConversationModel(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      userImage: userImage ?? this.userImage,
      lastMessage: lastMessage ?? this.lastMessage,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory UserConversationModel.fromJson(Map<String, dynamic> json) {
    return UserConversationModel(
      id: json['id'] as String,
      userName: json['userName'] as String,
      userImage: json['userImage'] as String,
      lastMessage: json['lastMessage'] ?? 'nothing yet',
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}


class ChatHistoryMessage {
  final int id;
  final String text;
  final String date;
  final String time;
  final bool isCurrentUserSentMessage;
  final bool isPending;

  ChatHistoryMessage({
    required this.id,
    required this.text,
    required this.date,
    required this.time,
    required this.isCurrentUserSentMessage,
    this.isPending = false
  });

    ChatHistoryMessage copyWith({
    bool? isPending,
  }) {
    return ChatHistoryMessage(
      id: id,
      text: text,
      isCurrentUserSentMessage: isCurrentUserSentMessage,
      time: time,
      date: date,
      isPending: isPending ?? this.isPending,
    );
  }

  factory ChatHistoryMessage.fromJson(Map<String, dynamic> json) {
    return ChatHistoryMessage(
      id: json['id'],
      text: json['text'],
      date: json['date'],
      time: json['time'],
      isCurrentUserSentMessage: json['isCurrentUserSentMessage'],
    );
  }
}

class ChatConversationData {
  final String currentUserId;
  final String receiverId;
  final String receiverUserName;
  final List<ChatHistoryMessage> chatHistory;

  ChatConversationData({
    required this.currentUserId,
    required this.receiverId,
    required this.receiverUserName,
    required this.chatHistory,
  });

  factory ChatConversationData.fromJson(Map<String, dynamic> json) {
    return ChatConversationData(
      currentUserId: json['currentUserId'],
      receiverId: json['receiverId'],
      receiverUserName: json['receiverUserName'],
      chatHistory: (json['chatHistory'] as List)
          .map((e) => ChatHistoryMessage.fromJson(e))
          .toList(),
    );
  }
}






