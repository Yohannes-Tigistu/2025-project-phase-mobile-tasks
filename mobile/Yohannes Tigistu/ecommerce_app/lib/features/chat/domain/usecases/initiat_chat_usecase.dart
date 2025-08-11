import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/success/confirmation.dart';
import '../entities/chat.dart';
import '../repository/chat_repository.dart';

class InitiateChatUsecase {
  final ChatRepository chatRepository;

  InitiateChatUsecase(this.chatRepository);

  Future<Either<Failures, Chat >> initiateChat(String userId) async {
    return await chatRepository.initiateChat(userId);
  }
}