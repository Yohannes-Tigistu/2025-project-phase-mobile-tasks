import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/success/confirmation.dart';
import '../entities/message.dart';
import '../repository/chat_repository.dart';

class SendMessageUsecase {
  final ChatRepository chatRepository;

  SendMessageUsecase(this.chatRepository);

  Future<Either<Failures, void>> sendMessage(Message message) async {
    return await chatRepository.sendMessage(message);
  }
}