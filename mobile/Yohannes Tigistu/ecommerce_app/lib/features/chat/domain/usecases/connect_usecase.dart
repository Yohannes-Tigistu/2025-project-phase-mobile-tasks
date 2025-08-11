import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repository/chat_repository.dart';

class ConnectUsecase {
  final ChatRepository repository;
  ConnectUsecase(this.repository);

  Future<Either<Failures, void>> call(
  
  ) async {
    return await repository.connect();
  }
}
