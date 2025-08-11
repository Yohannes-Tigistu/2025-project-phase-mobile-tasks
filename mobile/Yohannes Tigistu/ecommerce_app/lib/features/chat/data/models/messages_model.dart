import '../../../authentication/data/models/user_model.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';
import 'chat_model.dart';

class MessagesModel extends Message {
  MessagesModel({
    required String id,
    required Chat chat,
    required String content,
    required UserModel sender,
    required DateTime timestamp,
  }) : super(
         id: id,
         chat: chat,
         content: content,
         sender: sender,
         timestamp: timestamp,
       );

  // need to come back to refactor this .
  factory MessagesModel.fromJson(Map<String, dynamic> json) {
    // id can be `id` or `_id`
    final String id = (json['id'] ?? json['_id'] ?? '').toString();

    // content can be `content` or `text`
    final String content = (json['content'] ?? json['text'] ?? '').toString();

    // timestamp may be `createdAt` or `timestamp`
    final String? tsRaw = (json['createdAt'] ?? json['timestamp'])?.toString();
    final DateTime timestamp = () {
      try {
        return tsRaw != null ? DateTime.parse(tsRaw) : DateTime.now();
      } catch (_) {
        return DateTime.now();
      }
    }();

    // sender may be a full user object or just an id
    final dynamic senderRaw = json['sender'] ?? json['senderId'];
    final UserModel sender = () {
      if (senderRaw is Map<String, dynamic>) {
        return UserModel.fromJson(senderRaw);
      }
      if (senderRaw is String) {
        return UserModel(id: senderRaw, name: '', email: '');
      }
      return UserModel(id: '', name: '', email: '');
    }();

    // chat may be a full chat object or just an id
    final dynamic chatRaw = json['chat'] ?? json['chatId'];
    final ChatModel chat = () {
      if (chatRaw is Map<String, dynamic>) {
        return ChatModel.fromJson(chatRaw);
      }
      final String chatId = chatRaw?.toString() ?? '';
      return ChatModel(
        chatId: chatId,
        user1: UserModel(id: '', name: '', email: ''),
        user2: UserModel(id: '', name: '', email: ''),
      );
    }();

    return MessagesModel(
      id: id,
      chat: chat,
      content: content,
      sender: sender,
      timestamp: timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat': (chat as ChatModel).toJson(),
      'content': content,
      // Keep key as `sender` since it holds the full object
      'sender': (sender as UserModel).toJson(),
    };
  }
}
