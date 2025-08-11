import '../../../authentication/data/models/user_model.dart';

import '../../domain/entities/chat.dart';

class ChatModel extends Chat {
  ChatModel({
    required String chatId,
    required UserModel user1,
    required UserModel user2,
  }) : super(chatId: chatId, user1: user1, user2: user2);

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      chatId: json['id'] ?? json['chatId'] ?? json['_id'],
      user1: UserModel.fromJson(json['user1']),
      user2: UserModel.fromJson(json['user2']),
    );
  }
  factory ChatModel.fromModel(Chat chat) {
    return ChatModel(
      chatId: chat.chatId,
      user1: chat.user1 as UserModel,
      user2: chat.user2 as UserModel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': chatId,
      'user1': (user1 as UserModel).toJson(),
      'user2': (user2 as UserModel).toJson(),
    };
  }
}
