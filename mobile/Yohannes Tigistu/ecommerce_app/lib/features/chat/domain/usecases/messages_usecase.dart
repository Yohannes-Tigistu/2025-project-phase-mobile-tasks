import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/message.dart';
import '../repository/chat_repository.dart';

class MessagesUsecase {
  final ChatRepository chatRepository;

  MessagesUsecase(this.chatRepository);

  Future<Either<Failures, List<Message>>> messages(String chatId) async {
    return await chatRepository.messages(chatId);
  }
}