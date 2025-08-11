import '../../../authentication/domain/entities/user.dart';

class Chat {
  final String chatId;
  final User user1;
  final User user2;

  Chat({
    required this.chatId,
    required this.user1,
    required this.user2,
  });
}