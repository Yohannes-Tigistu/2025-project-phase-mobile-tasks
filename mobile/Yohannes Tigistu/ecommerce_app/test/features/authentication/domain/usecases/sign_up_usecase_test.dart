import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart';
import 'package:ecommerce_app/features/authentication/domain/entities/user.dart';
import 'package:ecommerce_app/features/authentication/domain/repository/auth_repository.dart';
import 'package:ecommerce_app/features/authentication/domain/usecases/sign_up_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import '../../data/repository/auth_repository_impl_test.dart';
import 'sign_up_usecase_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepository mockAuthRepository;
  late SignUpUsecase signUpUsecase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    signUpUsecase = SignUpUsecase(mockAuthRepository);
  });

  group('SignUpUsecase', () {
    const testEmail = 'test@example.com';
    const testPassword = 'password123';
    const testName = 'Test User';
    User testUser = User(id: '1', name: testName, email: testEmail);

    test(
      'should call signUp on the repository with correct parameters',
      () async {
        // Arrange
        when(
          mockAuthRepository.signup(any, any, any),
        ).thenAnswer((_) async => Future.value(Right(testUser)));

        // Act
        final result = await signUpUsecase(testEmail, testName, testPassword);

        // Assert
        expect(result, Right(testUser));
        verify(mockAuthRepository.signup(any, any, any));
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );
    test('should return failure when signUp fails', () async {
      // Arrange
      when(
        mockAuthRepository.signup(any, any, any),
      ).thenAnswer((_) async => Left(AuthenticationFailure(authenticationFailureMessage)));

      // Act
      final result = await signUpUsecase(testEmail, testName, testPassword);

      // Assert
      expect(result, Left(AuthenticationFailure(authenticationFailureMessage)));
      verify(mockAuthRepository.signup(any, any, any));
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });
}
