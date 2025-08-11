import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/errors/exeption.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signup(String email, String name, String password);
  Future<String> login(String email, String password);
  Future<UserModel> getCurrentUser(String token);
}

final signupUri = Uri.parse(
  'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v2/auth/register',
);
final loginUri = Uri.parse(
  'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v2/auth/login',
);
final getUserUri = Uri.parse(
  'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v2/users/me',
);

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  // This class would implement the methods to interact with a remote API
  // For example, using http package to make network requests
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> signup(String name, String email, String password) async {
    final response = await client.post(
      signupUri,
      body: json.encode({'name': name, 'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );
   
    if (response.statusCode == 201) {

      final data = (json.decode(response.body))['data'];
      return UserModel.fromJson(data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<String> login(String email, String password) async {
    final response = await client.post(
      loginUri,
      body: json.encode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      var accessToken = data['data'];
      
      
      return accessToken['access_token']; // Assuming the token is returned in the response
    } else {
    
      throw ServerException();
    }
  }

  @override
  Future<UserModel> getCurrentUser(String token) async {
    final response = await client.get(
      getUserUri,
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final data = (json.decode(response.body))['data'];

      return UserModel.fromJson(data);
    } else {
      throw ServerException();
    }
  }
}
