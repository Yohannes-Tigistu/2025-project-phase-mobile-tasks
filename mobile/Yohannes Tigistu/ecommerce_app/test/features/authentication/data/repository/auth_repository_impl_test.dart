import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/core/network/network_info.dart';
import 'package:ecommerce_app/features/authentication/data/datasources/auth_local_data_source.dart';
import 'package:ecommerce_app/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:ecommerce_app/features/authentication/data/models/user_model.dart';
import 'package:ecommerce_app/features/authentication/data/repository/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_repository_impl_test.mocks.dart';

@GenerateMocks([NetworkInfo, AuthRemoteDataSource, AuthLocalDataSource])
const serverFailureMessage = 'Server failure';
const cacheFailureMessage = 'Cache failure';
const networkFailureMessage = 'Network failure';
const authenticationFailureMessage = 'Authentication failure';

void main() {
  late AuthRepositoryImpl authRepository;
  late MockNetworkInfo mockNetworkInfo;
  late MockAuthRemoteDataSource mockRemoteDataSource;
  late MockAuthLocalDataSource mockLocalDataSource;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockRemoteDataSource = MockAuthRemoteDataSource();
    mockLocalDataSource = MockAuthLocalDataSource();
    authRepository = AuthRepositoryImpl(
      networkInfo: mockNetworkInfo,
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  group('AuthRepositoryImpl', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password';
    const testName = 'Test User';
    final tUser = UserModel(id: '1', email: testEmail, name: testName);

    group('login', () {
      // Add tests for AuthRepositoryImpl.login() here
      test('should return a User on successful login', () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          mockRemoteDataSource.login(any, any),
        ).thenAnswer((_) async => 'token');
        when(mockLocalDataSource.cacheToken(any)).thenAnswer((_) async => {});
        when(mockLocalDataSource.getToken()).thenAnswer((_) async => 'token');
        when(
          mockRemoteDataSource.getCurrentUser(any),
        ).thenAnswer((_) async => tUser);

        // Act
        final result = await authRepository.login(testEmail, testPassword);
        // Assert
        expect(result, Right(tUser));
        verify(mockRemoteDataSource.login(testEmail, testPassword));
        verify(mockLocalDataSource.cacheToken('token'));
        verify(mockLocalDataSource.getToken());
        verify(mockRemoteDataSource.getCurrentUser('token'));
      });
      test('should return Left(ServerFailure) on unsuccessful login', () async {
        // Arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          mockRemoteDataSource.login(any, any),
        ).thenThrow(ServerFailure(serverFailureMessage));

        // Act
        final result = await authRepository.login(testEmail, testPassword);

        // Assert
        expect(result, equals(Left(ServerFailure(serverFailureMessage))));
      });
      // network failure
      test(
        'should return Left(NetworkFailure) when not connected to the network',
        () async {
          // Arrange
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

          // Act
          final result = await authRepository.login(testEmail, testPassword);

          // Assert
          expect(result, equals(Left(NetworkFailure(networkFailureMessage))));
        },
      );

      group('logout', () {
        // Add tests for AuthRepositoryImpl.logout() here
        test(
          'should return Right(Confirmation) on successful logout',
          () async {
            // Arrange
            when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
            when(
              mockLocalDataSource.clearToken(),
            ).thenAnswer((_) async => null);

            // Act
            final result = await authRepository.logout();

            // Assert
            expect(result, isA<Right>());
            verify(mockLocalDataSource.clearToken());
          },
        );
        // cache failure
        test(
          'should return Left(CacheFailure) on unsuccessful logout',
          () async {
            // Arrange
            when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
            when(
              mockLocalDataSource.clearToken(),
            ).thenThrow(CacheFailure(cacheFailureMessage));

            // Act
            final result = await authRepository.logout();

            // Assert
            expect(result, equals(Left(CacheFailure(cacheFailureMessage))));
          },
        );
        // network failure
        test(
          'should return Left(NetworkFailure) when not connected to the network',
          () async {
            // Arrange
            when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

            // Act
            final result = await authRepository.logout();

            // Assert
            expect(result, equals(Left(NetworkFailure(networkFailureMessage))));
          },
        );
      });

      group('signup', () {
        // Add tests for AuthRepositoryImpl.signup() here
        test('should return Right(UserModel) on successful signup', () async {
          // Arrange
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          when(
            mockRemoteDataSource.signup(any, any, any),
          ).thenAnswer((_) async => tUser);

          // Act
          final result = await authRepository.signup(
            testEmail,
            testName,
            testPassword,
          );

          // Assert
          expect(result, equals(Right(tUser)));
          verify(
            mockRemoteDataSource.signup(testEmail, testName, testPassword),
          );
        });
        // server failure
        test(
          'should return Left(ServerFailure) on unsuccessful signup',
          () async {
            // Arrange
            when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
            when(
              mockRemoteDataSource.signup(any, any, any),
            ).thenThrow(ServerFailure(serverFailureMessage));

            // Act
            final result = await authRepository.signup(
              testEmail,
              testName,
              testPassword,
            );

            // Assert
            expect(result, equals(Left(ServerFailure(serverFailureMessage))));
          },
        );
        // network failure
        test(
          'should return Left(NetworkFailure) when not connected to the network',
          () async {
            // Arrange
            when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

            // Act
            final result = await authRepository.signup(
              testEmail,
              testName,
              testPassword,
            );

            // Assert
            expect(result, equals(Left(NetworkFailure(networkFailureMessage))));
          },
        );
      });
    });
  });
}
