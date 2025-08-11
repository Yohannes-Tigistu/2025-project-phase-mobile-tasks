import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../authentication/domain/entities/user.dart';
import '../repository/chat_repository.dart';

class GetUsersUsecase {
  final ChatRepository chatRepository;

  GetUsersUsecase(this.chatRepository);

  Future<Either<Failures, List<User>>> getUsers() async {
    return await chatRepository.getUsers();
  }
}