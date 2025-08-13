import 'package:equatable/equatable.dart';

import '../../../authentication/domain/entities/user.dart';
import 'chat.dart';

class Message extends Equatable {
  final String id;
  final Chat chat;
  final User sender;
  final String content;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.chat,
    required this.sender,
    required this.content,
    required this.timestamp,
  });
  
  Message.empty()
      : id = '',
        chat = Chat(chatId: '', user1: User(id: '', name: '', email: ''), user2: User(id: '', name: '', email: '')),
        sender = User(id: '', name: '', email: ''),
        content = '',
        timestamp = DateTime.now();

  @override
  List<Object?> get props => [id, chat, sender, content, timestamp];
}
