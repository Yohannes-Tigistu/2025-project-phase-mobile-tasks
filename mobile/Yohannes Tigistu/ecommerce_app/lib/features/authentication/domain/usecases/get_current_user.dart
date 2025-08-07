import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repository/auth_repository.dart';

class GetCurrentUser {
  final AuthRepository authRepository;

  GetCurrentUser(this.authRepository);

  Future<Either<Failures, User>> call() {
    return authRepository.getCurrentUser();
  }
}