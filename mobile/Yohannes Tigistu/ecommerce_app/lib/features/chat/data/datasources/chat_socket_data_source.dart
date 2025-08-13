import 'dart:async';

// import 'dart:io'; // Still commented; not needed unless overriding HTTP for insecure connections

import 'package:dartz/dartz.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../../core/errors/failures.dart';
import '../../domain/entities/message.dart';
import '../models/messages_model.dart';

/// Socket data source for real-time chat via Socket.IO
/// - Handles connect/disconnect, join room, send message with ack, and streams
/// - Exposes message and typing streams; consumers map payloads to models/entities
abstract class ChatSocketDataSource {
  Future<void> connect({required String socketBaseUrl, required String token});

  Future<bool> sendMessage({required String chatId, required String content});
  Stream<Either<Failures, Message>> get messageReceivedStream;
  Stream<Either<Failures, Message>> get messageDeliveredStream;
  Future<void> joinRoom(String chatId);
  Future<void> disconnect();
  // Optional: callback-based listeners (raw JSON payloads)
  void setListeners({
    void Function()? onConnected,
    void Function()? onDisconnected,
    void Function(Map<String, dynamic> message)? onMessageReceived,
    void Function(Map<String, dynamic> message)? onMessageDelivered,
    void Function(String error)? onMessageError,
  });
}

// Base URL is provided by repository; no fixed constant needed here.
const String serverFailureMessage = 'Server Failure';

class ChatSocketDataSourceImpl implements ChatSocketDataSource {
  IO.Socket? _socket;
  String? _activeChatId;

  final _receivedController =
      StreamController<Either<Failures, MessagesModel>>.broadcast();
  // final _typingCtrl = StreamController<MessagesModel>>.broadcast();
  final _deliveredController =
      StreamController<Either<Failures, MessagesModel>>.broadcast();

  Completer<void>? _connectionCompleter;
  bool _isConnected = false;

  // Error stream for socket errors
  final _errorController = StreamController<String>.broadcast();

  // Callback fields
  void Function()? _onConnectedCb;
  void Function()? _onDisconnectedCb;
  void Function(Map<String, dynamic> message)? _onMessageReceivedCb;
  void Function(Map<String, dynamic> message)? _onMessageDeliveredCb;
  void Function(String error)? _onMessageErrorCb;

  @override
  void setListeners({
    void Function()? onConnected,
    void Function()? onDisconnected,
    void Function(Map<String, dynamic> message)? onMessageReceived,
    void Function(Map<String, dynamic> message)? onMessageDelivered,
    void Function(String error)? onMessageError,
  }) {
    _onConnectedCb = onConnected;
    _onDisconnectedCb = onDisconnected;
    _onMessageReceivedCb = onMessageReceived;
    _onMessageDeliveredCb = onMessageDelivered;
    _onMessageErrorCb = onMessageError;
  }

  @override
  Future<void> connect({
    required String socketBaseUrl,
    required String token,
  }) async {
    if (_isConnected) {
      print('⚠️ Socket already connected');
      return;
    }

    _connectionCompleter = Completer<void>();

    _socket = IO.io(
      socketBaseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableForceNew()
          .enableAutoConnect() // be explicit
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .build(),
    );

    _socket!.onConnect((_) {
      _isConnected = true;
      print('✅ Socket connected to $socketBaseUrl');
      _onConnectedCb?.call(); // FIX: Invoke the connected callback if set
      _connectionCompleter?.complete();
    });

    _socket!.onDisconnect((_) {
      _isConnected = false;
      print('❌ Socket disconnected');
      _onDisconnectedCb?.call(); // FIX: Invoke the disconnected callback if set
      // FIX: Only error the completer if it's during initial connection (not completed yet)
      if (!(_connectionCompleter?.isCompleted ?? true)) {
        _connectionCompleter?.completeError(
          ServerFailure('Disconnected during connection'),
        );
      }
    });

    _socket!.onReconnect((_) => print('🔄 Socket reconnected'));
    _socket!.onReconnectAttempt((_) => print('⏳ Attempting to reconnect...'));
    _socket!.onConnectError((err) {
      print('🚨 Socket connection error: $err');
      if (!(_connectionCompleter?.isCompleted ?? true)) {
        _connectionCompleter?.completeError(
          ServerFailure('Socket connection error'),
        );
      }
      _errorController.add(err.toString());
    });

    // Listen for incoming messages
    _socket!.on('message:received', (data) {
      print('📩 Raw received message: $data');
      // FIX: Safely cast and invoke callback before parsing
      if (data is Map<String, dynamic>) {
        _onMessageReceivedCb?.call(data);
      } else {
        print(
          '⚠️ Unexpected data type for received message: ${data.runtimeType}',
        );
      }
      try {
        final message = MessagesModel.fromJson(Map<String, dynamic>.from(data));
        _receivedController.add(Right(message));
      } catch (e) {
        print('⚠️ Error parsing received message: $e');
        _receivedController.add(Left(ServerFailure(serverFailureMessage)));
      }
    });

    // Listen for delivery confirmations
    _socket!.on('message:delivered', (data) {
      print('📬 Raw delivery confirmation: $data');
      // FIX: Safely cast and invoke callback
      if (data is Map<String, dynamic>) {
        _onMessageDeliveredCb?.call(data);
      } else {
        print(
          '⚠️ Unexpected data type for delivered message: ${data.runtimeType}',
        );
      }
      try {
        final message = MessagesModel.fromJson(Map<String, dynamic>.from(data));
        _deliveredController.add(Right(message));
      } catch (e) {
        _deliveredController.add(Left(ServerFailure(serverFailureMessage)));
      }
    });

    // Listen for errors
    _socket!.on('message:error', (data) {
      print('🚨 Message error event: $data');
      String errorMsg = 'Unknown message error';
      if (data is Map && data['error'] != null) {
        errorMsg = data['error'].toString();
      } else if (data != null) {
        errorMsg = data.toString();
      }
      _errorController.add(errorMsg);
      _onMessageErrorCb?.call(
        errorMsg,
      ); // FIX: Invoke the error callback if set
    });

    // Explicit connect (harmless if already connecting) for reliability on some platforms
    _socket!.connect();

    return _connectionCompleter!.future;
  }

  @override
  Future<void> joinRoom(String chatId) async {
    _activeChatId = chatId;
    // Emit multiple variants to maximize compatibility with backend naming.
    final payload = {'chatId': chatId};
    _socket?.emit('join', payload);
    _socket?.emit('chat:join', payload);
    _socket?.emit('room:join', payload);
    print(
      '🔗 Sent join events for chat room: $chatId -> join | chat:join | room:join',
    );
  }

  @override
  Future<bool> sendMessage({
    required String chatId,
    required String content,
  }) async {
    if (!_isConnected) {
      print('❌ Cannot send message — socket not connected.');
      return false;
    }

    final completer = Completer<bool>();
    final payload = {
      'chatId': chatId,
      'content': content,
      'type': 'text',
      // Provide activeChatId redundancy if server differentiates
    };

    print('📤 Emitting message:send with ack -> $payload');

    bool ackHandled = false;
    // Fallback timeout in case server never acks
    Timer(const Duration(seconds: 6), () {
      if (!ackHandled && !completer.isCompleted) {
        print('⌛ Ack timeout – assuming message send failure');
        completer.complete(false);
      }
    });

    try {
      _socket!.emitWithAck(
        'message:send',
        payload,
        ack: (data) {
          ackHandled = true;
          if (data is Map && data.containsKey('error')) {
            final errorMessage = data['error'].toString();
            print('🚨 Message send failed with error: $errorMessage');
            _errorController.add(errorMessage);
            _onMessageErrorCb?.call(errorMessage);
            if (!completer.isCompleted) completer.complete(false);
          } else {
            print('✅ Message acknowledged by server successfully.');
            if (!completer.isCompleted) completer.complete(true);
          }
        },
      );
    } catch (e) {
      print('🚨 emitWithAck threw: $e – falling back to plain emit');
      _socket!.emit('message:send', payload);
      // Optimistically succeed (delivered event should still confirm)
      if (!completer.isCompleted) completer.complete(true);
    }

    return completer.future;
  }

  @override
  Stream<Either<Failures, Message>> get messageReceivedStream =>
      _receivedController.stream.map(
        (eitherModel) => eitherModel.map((model) => model.toEntity()),
      );

  @override
  Stream<Either<Failures, Message>> get messageDeliveredStream =>
      _deliveredController.stream.map(
        (eitherModel) => eitherModel.map((model) => model.toEntity()),
      );

  Stream<String> get errorStream => _errorController.stream;

  @override
  Future<void> disconnect() async {
    if (!_isConnected) {
      print('⚠️ Socket is not connected');
      return;
    }
    _socket?.disconnect(); // Disconnect first
    _socket?.dispose(); // Then dispose to clean up listeners and resources
    _isConnected = false;
    _activeChatId = null;
    print('🔌 Socket manually disconnected');
    // Controllers not closed – good for potential reuse
  }
}
