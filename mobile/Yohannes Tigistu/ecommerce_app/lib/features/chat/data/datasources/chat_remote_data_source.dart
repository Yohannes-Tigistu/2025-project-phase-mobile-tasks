import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../../core/errors/exeption.dart';
import '../../../../core/success/confirmation.dart';
import '../../../authentication/data/models/user_model.dart';
import '../../domain/entities/chat.dart';
import '../models/chat_model.dart';
import '../models/messages_model.dart';

/// Remote data source for chat REST endpoints (v3).
///
/// Implements:
/// - POST /api/v3/chats to initiate a chat between the current user and [userId]
/// - DELETE /api/v3/chats/:chatId to delete a chat
///
/// Note: This layer returns raw Map payloads (data JSON). Mapping to models/entities
/// should be done in the repository/model layer to keep concerns separated.
abstract class ChatRemoteDataSource {
  /// Initiate a new chat with another user. Returns the created chat JSON (data field).
  Future<ChatModel> initiateChat({
    required String baseUrl,
    required String token,
    required String userId,
  });

  /// Delete an existing chat by id. Returns when successful, throws on failure.
  Future<Confirmation> deleteChat({
    required String baseUrl,
    required String token,
    required String chatId,
  });

  /// Get list of chats for the current user. Returns a list of chat JSON objects.
  /// Throws [ServerException] on error.
  Future<List<ChatModel>> getChats({
    required String baseUrl,
    required String token,
  });

  /// Get list of messages for a chat. Returns a list of message JSON objects.
  /// Throws [ServerException] on error.
  Future<List<MessagesModel>> getMessages({
    required String baseUrl,
    required String token,
    required String chatId,
  });

  /// Get list of users. Returns a list of user JSON objects.
  /// Throws [ServerException] on error.
  Future<List<UserModel>> getUsers({
    required String baseUrl,
    required String token,
  });
}

const String deleteChatConfirmationMessage = 'Chat deleted successfully';

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final http.Client client;

  ChatRemoteDataSourceImpl({required this.client});

  Map<String, String> _headers(String token) => {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  Uri _uri(String baseUrl, String path) => Uri.parse('$baseUrl$path');

  @override
  Future<ChatModel> initiateChat({
    required String baseUrl,
    required String token,
    required String userId,
  }) async {
    final uri = _uri(baseUrl, '/api/v3/chats');
    print('DEBUG: Initiating chat at $uri with userId: $userId');
    final response = await client.post(
      uri,
      headers: _headers(token),
      body: json.encode({'userId': userId}),
    );

    print('DEBUG: initiateChat response status: ${response.statusCode}');
    print('DEBUG: initiateChat response body: ${response.body}');

    // v3 responses are typically { statusCode, message, data }
    if (response.statusCode == 201 || response.statusCode == 200) {
      //dont need to return anything
      final jsonBody = json.decode(response.body)['data'];
      print('DEBUG: initiateChat success: ${jsonBody}');
      return ChatModel.fromJson(jsonBody);
    } else {
      print('DEBUG: initiateChat failed with status ${response.statusCode}');
      throw ServerException();
    }
  }

  @override
  Future<Confirmation> deleteChat({
    required String baseUrl,
    required String token,
    required String chatId,
  }) async {
    final uri = _uri(baseUrl, '/api/v3/chats/$chatId');
    print('DEBUG: Deleting chat at $uri');
    final response = await client.delete(uri, headers: _headers(token));

    print('DEBUG: deleteChat response status: ${response.statusCode}');
    print('DEBUG: deleteChat response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 204) {
      print('DEBUG: deleteChat success');
      return Confirmation(deleteChatConfirmationMessage);
    }
    // Some docs show no body; treat non-2xx as failure
    print('DEBUG: deleteChat failed with status ${response.statusCode}');
    throw ServerException();
  }

  //? get list of chats
  @override
  Future<List<ChatModel>> getChats({
    required String baseUrl,
    required String token,
  }) async {
    final uri = _uri(baseUrl, '/api/v3/chats');
    print('DEBUG: Getting chats from $uri');
    final response = await client.get(uri, headers: _headers(token));

    print('DEBUG: getChats response status: ${response.statusCode}');
    print('DEBUG: getChats response body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body) as Map<String, dynamic>;
      final data = (jsonBody['data'] ?? []) as List<dynamic>;
      print('DEBUG: getChats success');
      final chats = data.map((item) => ChatModel.fromJson(item)).toList();
      print('DEBUG: getChats success, found ${chats.length} chats');
      print(chats);
      return chats;
    }
    print('DEBUG: getChats failed with status ${response.statusCode}');
    throw ServerException();
  }

  // get list of messages
  @override
  Future<List<MessagesModel>> getMessages({
    required String baseUrl,
    required String token,
    required String chatId,
  }) async {
    final uri = _uri(baseUrl, '/api/v3/chats/$chatId/messages');
    print('DEBUG: Getting messages from $uri');
    final response = await client.get(uri, headers: _headers(token));

    print('DEBUG: getMessages response status: ${response.statusCode}');
    print('DEBUG: getMessages response body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body) as Map<String, dynamic>;
      final data = (jsonBody['data'] ?? []) as List<dynamic>;
      print(data);
      final messages = data
          .map((item) => MessagesModel.fromJson(item))
          .toList();
      print('DEBUG: getMessages success, found ${messages.length} messages');
      return messages;
    } else {
      print('DEBUG: getMessages failed with status ${response.statusCode}');
      throw ServerException();
    }
  }

  // get users
  @override
  Future<List<UserModel>> getUsers({
    required String baseUrl,
    required String token,
  }) async {
    final uri = _uri(baseUrl, '/api/v3/users');
    log('DEBUG: Getting users from $uri');
    final response = await client.get(uri, headers: _headers(token));

    log('DEBUG: getUsers response status: ${response.statusCode}');
    // log('DEBUG: getUsers response body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body) as Map<String, dynamic>;
      final data = (jsonBody['data'] ?? []) as List<dynamic>;

      final List<UserModel> users = data.isNotEmpty
          ? data.map((item) => UserModel.fromJson(item)).toList()
          : [];
      log('DEBUG: getUsers success, found ${users.length} users');
      return users;
    } else {
      log('DEBUG: getUsers failed with status ${response.statusCode}');
      throw ServerException();
    }
  }
}
