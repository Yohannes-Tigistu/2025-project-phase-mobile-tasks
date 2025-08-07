

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/success/confirmation.dart';
import '../../domain/entities/user.dart';
import '../../domain/repository/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

const serverFailureMessage = 'Server failure';
const cacheFailureMessage = 'Cache failure';
const networkFailureMessage = 'Network failure';
const authenticationFailureMessage = 'Authentication failure';

class AuthRepositoryImpl implements AuthRepository {
  final NetworkInfo networkInfo;
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.networkInfo,
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failures, UserModel>> login(String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final token = await remoteDataSource.login(email, password);
        await localDataSource.cacheToken(token);
        return await getCurrentUser();
      } catch (e) {
        return Left(ServerFailure(serverFailureMessage));
      }
    } else {
      return Left(NetworkFailure(networkFailureMessage));
    }
  }

  @override
  Future<Either<Failures, User>> signup(
    String email,
    String name,
    String password,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final userModel = await remoteDataSource.signup(email, name, password);
        return Right(userModel);
      } catch (e) {
        return Left(ServerFailure(serverFailureMessage));
      }
    } else {
      return Left(NetworkFailure(networkFailureMessage ));
    }
  }

  @override
  Future<Either<Failures, Confirmation>> logout() async {
    if (await networkInfo.isConnected) {
      try {
        await localDataSource.clearToken();
        return Right(Confirmation('Logged out successfully'));
      } catch (e) {
        return Left(CacheFailure(cacheFailureMessage));
      }
    } else {
      return Left(NetworkFailure(networkFailureMessage));
    }
  }

  @override
  Future<Either<Failures,  UserModel>> getCurrentUser() async {
    if (await networkInfo.isConnected) {
      try {
        final token = await localDataSource.getToken();
        if (token != null) {
          final userModel = await remoteDataSource.getCurrentUser(token);
          return Right(userModel);
        } else {
          return Left(CacheFailure(cacheFailureMessage));
        }
      } catch (e) {
        return Left(ServerFailure(serverFailureMessage));
      }
    } else {
      return Left(NetworkFailure(networkFailureMessage));
    }
  }
}
