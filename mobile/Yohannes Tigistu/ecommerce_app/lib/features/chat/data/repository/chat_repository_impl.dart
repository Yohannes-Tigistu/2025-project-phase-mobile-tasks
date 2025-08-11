import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/success/confirmation.dart';

import '../../../authentication/domain/entities/user.dart';
import '../../domain/entities/message.dart';
import '../../domain/repository/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';
import '../datasources/chat_socket_data_source.dart';
import '../../domain/entities/chat.dart';
import '../models/messages_model.dart';

const String networkFailureMessage = 'No Internet Connection';
const String serverFailureMessage = 'Server Error';
const CACHED_AUTH_TOKEN = 'CACHED_AUTH_TOKEN';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final ChatSocketDataSource socketDataSource;
  final NetworkInfo networkInfo;
  final SharedPreferences sharedPreferences;

  bool _connected = false;
  ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.socketDataSource,
    required this.networkInfo,
    required this.sharedPreferences,
  });
  // Use v3 host. Socket.IO client can use https base; it will upgrade to websockets.
  final String socketBase =
      'wss://g5-flutter-learning-path-be-tvum.onrender.com';
  final String apiBaseUrl =
      'https://g5-flutter-learning-path-be-tvum.onrender.com';

  @override
  Future<Either<Failures, Chat>> initiateChat(String userId) async {
    print('[chat_repository_impl.dart] Initiate chat for user ID: $userId');
    final String token = sharedPreferences.getString(CACHED_AUTH_TOKEN) ?? '';
    print('[chat_repository_impl.dart] Cached token: $token');
    if (await networkInfo.isConnected) {
      try {
        print('[chat_repository_impl.dart] Initiating chat remotely...');
        final result = await remoteDataSource.initiateChat(
          baseUrl: apiBaseUrl,
          token: token,
          userId: userId,
        );
        print(
          '[chat_repository_impl.dart] Chat initiation successful: $result',
        );
        // Upcast ChatModel to Chat
        
      
        return Right(result);
      } catch (e) {
        print('[chat_repository_impl.dart] Chat initiation failed: $e');
        return Left(ServerFailure(serverFailureMessage));
      }
    } else {
      print('[chat_repository_impl.dart] No internet connection');
      return Left(NetworkFailure(networkFailureMessage));
    }
  }

  @override
  Future<Either<Failures, Confirmation>> deleteChat(String chatId) async {
    print('[chat_repository_impl.dart] Deleting chat with ID: $chatId');
    final String token = sharedPreferences.getString(CACHED_AUTH_TOKEN) ?? '';
    print('[chat_repository_impl.dart] Cached token: $token');
    if (await networkInfo.isConnected) {
      try {
        print('[chat_repository_impl.dart] Deleting chat remotely...');
        final result = await remoteDataSource.deleteChat(
          baseUrl: apiBaseUrl,
          token: token,
          chatId: chatId,
        );
        print('[chat_repository_impl.dart] Chat deletion successful: $result');
        return Right(result);
      } catch (e) {
        print('[chat_repository_impl.dart] Chat deletion failed: $e');
        return Left(ServerFailure(serverFailureMessage));
      }
    } else {
      print('[chat_repository_impl.dart] No internet connection');
      return Left(NetworkFailure(networkFailureMessage));
    }
  }

  @override
  Future<Either<Failures, List<Chat>>> getChats() async {
    print('[chat_repository_impl.dart] Getting chats...');
    final String token = sharedPreferences.getString(CACHED_AUTH_TOKEN) ?? '';
    print('[chat_repository_impl.dart] Cached token: $token');

    if (await networkInfo.isConnected) {
      try {
        print('[chat_repository_impl.dart] Fetching chats remotely...');
        final list = await remoteDataSource.getChats(
          baseUrl: apiBaseUrl,
          token: token,
        );
        print('[chat_repository_impl.dart] Chats fetched successfully: $list');
        // Upcast List<ChatModel> to List<Chat>
        final chats = list.map<Chat>((e) => e).toList();
        return Right(chats);
      } catch (e) {
        print('[chat_repository_impl.dart] Failed to fetch chats: $e');
        return Left(ServerFailure(serverFailureMessage));
      }
    } else {
      print('[chat_repository_impl.dart] No internet connection');
      return Left(NetworkFailure(networkFailureMessage));
    }
  }

  @override
  Future<Either<Failures, List<Message>>> messages(String chatId) async {
    print('[chat_repository_impl.dart] Getting messages for chat ID: $chatId');
    final String token = sharedPreferences.getString(CACHED_AUTH_TOKEN) ?? '';
    print('[chat_repository_impl.dart] Cached token: $token');
    if (await networkInfo.isConnected) {
      try {
        print('[chat_repository_impl.dart] Fetching messages remotely...');
        final list = await remoteDataSource.getMessages(
          baseUrl: apiBaseUrl,
          token: token,
          chatId: chatId,
        );
        print(
          '[chat_repository_impl.dart] Messages fetched successfully: $list',
        );
        // Upcast List<MessagesModel> to List<Message>
        final messages = list.map<Message>((e) => e).toList();
        return Right(messages);
      } catch (e) {
        print('[chat_repository_impl.dart] Failed to fetch messages: $e');
        return Left(ServerFailure(serverFailureMessage));
      }
    } else {
      print('[chat_repository_impl.dart] No internet connection');
      return Left(NetworkFailure(networkFailureMessage));
    }
  }

  @override
  Future<Either<Failures, List<User>>> getUsers() async {
    print('[chat_repository_impl.dart] Getting users...');
    final String token = sharedPreferences.getString(CACHED_AUTH_TOKEN) ?? '';
    print('[chat_repository_impl.dart] Cached token: $token');

    if (await networkInfo.isConnected) {
      try {
        print('[chat_repository_impl.dart] Fetching users remotely...');
        final list = await remoteDataSource.getUsers(
          baseUrl: apiBaseUrl,
          token: token,
        );
        print('[chat_repository_impl.dart] Users fetched successfully: $list');
        // Upcast List<UserModel> to List<User>
        final users = list.map<User>((e) => e).toList();
        return Right(users);
      } catch (e) {
        print('[chat_repository_impl.dart] Failed to fetch users: $e');
        return Left(ServerFailure(serverFailureMessage));
      }
    } else {
      print('[chat_repository_impl.dart] No internet connection');
      return Left(NetworkFailure(networkFailureMessage));
    }
  }

  @override
  Future<Either<Failures, void>> sendMessage(Message message) async {
    print(
      '[chat_repository_impl.dart] Sending message: ${message.content} to chat ID: ${message.chat.chatId}',
    );
    if (await networkInfo.isConnected) {
      try {
        print('[chat_repository_impl.dart] Sending message via socket...');
        final ok = await socketDataSource.sendMessage(
          chatId: message.chat.chatId,
          content: message.content,
        );
        if (ok) {
          print('[chat_repository_impl.dart] Message sent successfully');
          return Right(null);
        }
        print('[chat_repository_impl.dart] Failed to send message');
        return Left(ServerFailure(serverFailureMessage));
      } catch (e) {
        print('[chat_repository_impl.dart] Failed to send message: $e');
        return Left(ServerFailure(serverFailureMessage));
      }
    } else {
      print('[chat_repository_impl.dart] No internet connection');
      return Left(NetworkFailure(networkFailureMessage));
    }
  }

  @override
  Future<Either<Failures, void>> connect() async {
    print('[chat_repository_impl.dart] Connecting to socket...');
    final String savedToken =
        sharedPreferences.getString(CACHED_AUTH_TOKEN) ?? '';
    // print('[chat_repository_impl.dart] Cached token: $');
    if (_connected) {
      print('[chat_repository_impl.dart] Already connected');
      return Right(null);
    }
    try {
      print('[chat_repository_impl.dart] Connecting to socket data source...');
      await socketDataSource.connect(
        socketBaseUrl: socketBase,
        token: savedToken,
      );
    } catch (e) {
      print('[chat_repository_impl.dart] Failed to connect to socket: $e');
      return Left(ServerFailure(serverFailureMessage));
    }
    _connected = true;
    print('[chat_repository_impl.dart] Connected to socket');
    return Right(null);
  }

  @override
  Future<Either<Failures, void>> joinRoom(String chatId) async {
    print('[chat_repository_impl.dart] Joining room with chat ID: $chatId');
    try {
      print('[chat_repository_impl.dart] Joining room via socket...');
      await socketDataSource.joinRoom(chatId);
      print('[chat_repository_impl.dart] Joined room successfully');
      return Right(null);
    } catch (e) {
      print('[chat_repository_impl.dart] Failed to join room: $e');
      return Left(ServerFailure(serverFailureMessage));
    }
  }

  @override
  Future<void> disconnect() async {
    print('[chat_repository_impl.dart] Disconnecting from socket...');
    if (!_connected) {
      print('[chat_repository_impl.dart] Not connected');
      return;
    }
    print('[chat_repository_impl.dart] Disconnecting socket data source...');
    await socketDataSource.disconnect();
    _connected = false;
    print('[chat_repository_impl.dart] Disconnected from socket');
  }

  @override
  Stream<Message> observeMessages() {
    print('[chat_repository_impl.dart] Observing messages...');
    return socketDataSource.messages().map((json) {
      print('[chat_repository_impl.dart] Received message: $json');
      return MessagesModel.fromJson(json);
    });
  }

  @override
  void setListeners({
    void Function()? onConnected,
    void Function()? onDisconnected,
    void Function(Message message)? onMessageReceived,
    void Function(Message message)? onMessageDelivered,
    void Function(String error)? onMessageError,
  }) {
    socketDataSource.setListeners(
      onConnected: onConnected,
      onDisconnected: onDisconnected,
      onMessageReceived: onMessageReceived == null
          ? null
          : (json) => onMessageReceived(MessagesModel.fromJson(json)),
      onMessageDelivered: onMessageDelivered == null
          ? null
          : (json) => onMessageDelivered(MessagesModel.fromJson(json)),
      onMessageError: onMessageError,
    );
  }
}
