import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/chat.dart';
import '../repository/chat_repository.dart';

class GetChatsUsecase {
  final ChatRepository chatRepository;

  GetChatsUsecase(this.chatRepository);

  Future<Either<Failures, List<Chat>>> getChats() async {
    return await chatRepository.getChats();
  }
}