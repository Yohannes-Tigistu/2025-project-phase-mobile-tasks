import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/success/confirmation.dart';
import '../../../authentication/domain/entities/user.dart';
import '../entities/chat.dart';
import '../entities/message.dart';

abstract class ChatRepository {
  Future<Either<Failures, void>> connect();
  Future<Either<Failures, void>> joinRoom(String chatId);
  Future<Either<Failures, Chat>> initiateChat(String userId);
  Future<Either<Failures, Confirmation>> deleteChat(String chatId);
  Future<Either<Failures, void>> sendMessage(Message message);
  Future<Either<Failures, List<User>>> getUsers();
  Future<Either<Failures, List<Chat>>> getChats();
  Future<Either<Failures, List<Message>>> messages(String chatId);

  /// Live messages stream from the socket for the currently joined room.
  Stream<Message> observeMessages();
  Future<void> disconnect();

  /// Optional: callback-based listeners for apps preferring observer pattern.
  void setListeners({
    void Function()? onConnected,
    void Function()? onDisconnected,
    void Function(Message message)? onMessageReceived,
    void Function(Message message)? onMessageDelivered,
    void Function(String error)? onMessageError,
  });
}
