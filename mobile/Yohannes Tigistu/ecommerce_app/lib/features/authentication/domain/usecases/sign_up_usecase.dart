import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repository/auth_repository.dart';

class SignUpUsecase {
  final AuthRepository authRepository;

  SignUpUsecase(this.authRepository);

  Future<Either<Failures, User>> call(
    String name,
    String email,
    String password,
  ) {
    return authRepository.signup(name, email, password);
  }
}
