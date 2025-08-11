import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repository/chat_repository.dart';

class JoinRoomUsecase {
  final ChatRepository chatRepository;

  JoinRoomUsecase(this.chatRepository);

  Future<Either<Failures, void>> call(String chatId) {
    return chatRepository.joinRoom(chatId);
  }
}
