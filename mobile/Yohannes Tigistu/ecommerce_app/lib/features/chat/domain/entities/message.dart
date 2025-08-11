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

  @override
  List<Object?> get props => [id, chat, sender, content, timestamp];
}
