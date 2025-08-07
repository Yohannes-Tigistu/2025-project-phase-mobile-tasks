import 'dart:convert';

import 'package:ecommerce_app/core/errors/exeption.dart';
import 'package:ecommerce_app/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:ecommerce_app/features/authentication/data/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'auth_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late AuthRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = AuthRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('signup', () {
    const tName = 'Test User';
    const tEmail = 'test@example.com';
    const tPassword = 'password123';
    final tUserModel = UserModel(id: '1', name: tName, email: tEmail);
    final tUserJson = json.encode(tUserModel.toJson());

    test(
      'should return UserModel when the response code is 201 (created)',
      () async {
        // arrange
        when(
          mockHttpClient.post(
            signupUri,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer((_) async => http.Response(tUserJson, 201));
        // act
        final result = await dataSource.signup(tEmail, tName, tPassword);
        // assert
        expect(result, equals(tUserModel));
      },
    );

    test(
      'should throw a ServerException when the response code is not 201',
      () async {
        // arrange
        when(
          mockHttpClient.post(
            signupUri,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer((_) async => http.Response('Something went wrong', 400));
        // act
        final call = dataSource.signup;
        // assert
        expect(
          () => call(tEmail, tName, tPassword),
          throwsA(isA<ServerException>()),
        );
      },
    );
  });

  group('login', () {
    const tEmail = 'test@example.com';
    const tPassword = 'password123';
    const tToken = 'test_token';

    test(
      'should return a token when the response code is 200 (success)',
      () async {
        // arrange
        when(
          mockHttpClient.post(
            loginUri,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer(
          (_) async => http.Response(json.encode({'token': tToken}), 200),
        );
        // act
        final result = await dataSource.login(tEmail, tPassword);
        // assert
        expect(result, equals(tToken));
        verify(
          mockHttpClient.post(
            loginUri,
            headers: {'Content-Type': 'application/json'},
            body: json.encode({'email': tEmail, 'password': tPassword}),
          ),
        );
        verifyNoMoreInteractions(mockHttpClient);
      },
    );

    test(
      'should throw a ServerException when the response code is not 200',
      () async {
        // arrange
        when(
          mockHttpClient.post(
            loginUri,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          ),
        ).thenAnswer((_) async => http.Response('Something went wrong', 401));
        // act
        final call = dataSource.login;
        // assert
        expect(() => call(tEmail, tPassword), throwsA(isA<ServerException>()));
      },
    );
  });

  group('getCurrentUser', () {
    const tToken = 'test_token';
    final tUserModel = UserModel(
      id: '1',
      name: 'Test User',
      email: 'test@example.com',
    );
    final tUserJson = json.encode(tUserModel.toJson());

    test(
      'should return UserModel when the response code is 200 (success)',
      () async {
        // arrange
        when(
          mockHttpClient.get(getUserUri, headers: anyNamed('headers')),
        ).thenAnswer((_) async => http.Response(tUserJson, 200));
        // act
        final result = await dataSource.getCurrentUser(tToken);
        // assert
        expect(result, equals(tUserModel));
        verify(
          mockHttpClient.get(
            getUserUri,
            headers: {'Authorization': 'Bearer $tToken'},
          ),
        );
      },
    );

    test(
      'should throw a ServerException when the response code is not 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(getUserUri, headers: anyNamed('headers')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act
        final call = dataSource.getCurrentUser;
        // assert
        expect(() => call(tToken), throwsA(isA<ServerException>()));
      },
    );
  });
}
