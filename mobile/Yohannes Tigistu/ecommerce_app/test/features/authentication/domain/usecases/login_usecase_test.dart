import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/features/authentication/data/models/user_model.dart';
import 'package:ecommerce_app/features/authentication/data/repository/auth_repository_impl.dart';
import 'package:ecommerce_app/features/authentication/domain/usecases/login_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/mockito.dart';

import 'sign_up_usecase_test.mocks.dart';

void main(){
  late MockAuthRepository mockAuthRepository;
  late LoginUsecase loginUsecase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginUsecase = LoginUsecase(mockAuthRepository);
  });

  group('LoginUsecase', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';
    const testToken = 'test_token';
    final testUser = UserModel(id: '1', name: 'Test User', email: testEmail);
    test(
      'should call login on the repository with correct parameters',
      () async {
        // Arrange
        when(
          mockAuthRepository.login(testEmail, testPassword),
        ).thenAnswer((_) async => Future.value(Right(testUser)));

        // Act
        final result = await loginUsecase(testEmail, testPassword);

        // Assert
        expect(result,  Right(testUser));
        verify(mockAuthRepository.login(testEmail, testPassword));
        verifyNoMoreInteractions(mockAuthRepository);
      },
      
    );
    test('should return authentication failure when un able to login', () async {
      // Arrange
      final failure = AuthenticationFailure(authenticationFailureMessage);
      when(
        mockAuthRepository.login(testEmail, testPassword),
      ).thenAnswer((_) async => Left(failure));

      // Act
      final result = await loginUsecase(testEmail, testPassword);

      // Assert
      expect(result, Left(failure));
      verify(mockAuthRepository.login(testEmail, testPassword));
      verifyNoMoreInteractions(mockAuthRepository);
    });

  });}