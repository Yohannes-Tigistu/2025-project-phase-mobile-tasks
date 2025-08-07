import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/success/confirmation.dart';
import '../repository/auth_repository.dart';

class LogoutUsecase {
  final AuthRepository authRepository;

  LogoutUsecase(this.authRepository);

  Future<Either<Failures, Confirmation>> call() {
    return authRepository.logout();
  }
}