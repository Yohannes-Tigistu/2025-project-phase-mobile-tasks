//packages
import 'package:dartz/dartz.dart';
import 'package:ecommerce_app/core/errors/failures.dart' ;
import 'package:ecommerce_app/core/success/confirmation.dart';
import 'package:ecommerce_app/features/authentication/data/repository/auth_repository_impl.dart';
import 'package:ecommerce_app/features/authentication/domain/usecases/logout_usecase.dart';
import 'package:flutter_test/flutter_test.dart'; 
import 'package:mockito/mockito.dart';


import 'sign_up_usecase_test.mocks.dart';

void main(){
  late LogoutUsecase logoutUsecase;
  late MockAuthRepository mockAuthRepository;
  setUp(() {
    mockAuthRepository = MockAuthRepository();
    logoutUsecase = LogoutUsecase(mockAuthRepository);
  });
  group('logout tests', (){
    test('should call logout on the repository and return Confirmation on success', () async {
      // Arrange
      final confirmation = Confirmation('Logged out successfully');
      when(mockAuthRepository.logout()).thenAnswer((_) async => Right(confirmation));
      
      // Act
      final result = await logoutUsecase.call();
      
      // Assert
      expect(result, Right(confirmation));
      verify(mockAuthRepository.logout());
      verifyNoMoreInteractions(mockAuthRepository);
    });

    test('should return Failure when repository.logout fails', () async {
      // Arrange
      final failure = AuthenticationFailure(authenticationFailureMessage);
      when(mockAuthRepository.logout()).thenAnswer((_) async => Left(failure));
      
      // Act
      final result = await logoutUsecase.call();
      
      // Assert
      expect(result, Left(failure));
      verify(mockAuthRepository.logout());
      verifyNoMoreInteractions(mockAuthRepository);
    });

  });

}
