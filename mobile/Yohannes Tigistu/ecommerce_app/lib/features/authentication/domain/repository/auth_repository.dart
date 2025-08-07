import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/success/confirmation.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failures, User>> signup(
    String name,
    String email,
    String password,
  );
  Future<Either<Failures, User>> login(String email, String password);
  Future<Either<Failures, Confirmation>> logout();
  Future<Either<Failures, User>> getCurrentUser();
}
