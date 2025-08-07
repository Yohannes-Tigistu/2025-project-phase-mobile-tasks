import 'package:ecommerce_app/features/authentication/data/datasources/auth_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_local_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late AuthLocalDataSourceImpl authLocalDataSourceImpl;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    authLocalDataSourceImpl = AuthLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('cacheToken', () {
    test('should call SharedPreferences to cache the token', () async {
      // arrange
      const token = 'test_token';
      when(
        mockSharedPreferences.setString(any, any),
      ).thenAnswer((_) async => true);

      // act
      await authLocalDataSourceImpl.cacheToken(token);

      // assert
      verify(mockSharedPreferences.setString(CACHED_AUTH_TOKEN, token));
      verifyNoMoreInteractions(mockSharedPreferences);
    });
  });

  group('getToken', () {
    const tToken = 'test_token';
    test(
      'should return token from SharedPreferences when there is one in the cache',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn(tToken);

        // act
        final result = await authLocalDataSourceImpl.getToken();

        // assert
        verify(mockSharedPreferences.getString(CACHED_AUTH_TOKEN));
        expect(result, equals(tToken));
        verifyNoMoreInteractions(mockSharedPreferences);
      },
    );

    test('should return null when there is no token in the cache', () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      // act
      final result = await authLocalDataSourceImpl.getToken();

      // assert
      verify(mockSharedPreferences.getString(CACHED_AUTH_TOKEN));
      expect(result, isNull);
      verifyNoMoreInteractions(mockSharedPreferences);
    });
  });
}
