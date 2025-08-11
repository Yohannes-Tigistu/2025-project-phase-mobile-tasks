import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as IO;

/// Socket data source for real-time chat via Socket.IO
/// - Handles connect/disconnect, join room, send message with ack, and streams
/// - Exposes message and typing streams; consumers map payloads to models/entities
abstract class ChatSocketDataSource {
  Future<void> connect({required String socketBaseUrl, required String token});
  Future<void> joinRoom(String chatId);
  Future<bool> sendMessage({required String chatId, required String content});
  Stream<Map<String, dynamic>> messages();
  // Stream<Map<String, dynamic>> typing();
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

class ChatSocketDataSourceImpl implements ChatSocketDataSource {
  IO.Socket? _socket;
  String? _activeChatId;

  final _messageCtrl = StreamController<Map<String, dynamic>>.broadcast();
  // final _typingCtrl = StreamController<Map<String, dynamic>>.broadcast();

  // Callback handlers
  void Function()? _onConnectedCb;
  void Function()? _onDisconnectedCb;
  void Function(Map<String, dynamic>)? _onMessageReceivedCb;
  void Function(Map<String, dynamic>)? _onMessageDeliveredCb;
  void Function(String)? _onMessageErrorCb;

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
    if (_socket?.connected == true) return;

    final opts = IO.OptionBuilder()
        .setTransports(['websocket']) // Force WebSocket (not polling)
        .enableAutoConnect() // Auto-reconnect on disconnect
        .setExtraHeaders({
          // Send auth token in headers
          'Authorization': 'Bearer $token',
        })
        .build();

    _socket = IO.io(socketBaseUrl, opts);

    _socket!
      ..onConnect((_) {
        _onConnectedCb?.call();
        if (_activeChatId != null) {
          joinRoom(_activeChatId!);
        }
      })
      ..onReconnect((_) {
        if (_activeChatId != null) {
          joinRoom(_activeChatId!);
        }
      })
      ..onDisconnect((_) {
        _onDisconnectedCb?.call();
      })
      ..onError((e) {
        // Optionally emit an error payload to message stream
        _onMessageErrorCb?.call(e?.toString() ?? 'socket_error');
      })
      // Support both legacy 'message' and documented 'message:received'
      ..on('message', (data) {
        if (data is Map) {
          _messageCtrl.add(Map<String, dynamic>.from(data));
          _onMessageReceivedCb?.call(Map<String, dynamic>.from(data));
        }
      })
      ..on('message:received', (data) {
        if (data is Map) {
          final map = Map<String, dynamic>.from(data);
          _messageCtrl.add(map);
          _onMessageReceivedCb?.call(map);
        }
      })
      ..on('message:delivered', (data) {
        if (data is Map) {
          final map = Map<String, dynamic>.from(data);
          _messageCtrl.add(map);
          _onMessageDeliveredCb?.call(map);
        }
      });

    _socket!.connect();
  }

  @override
  Future<void> joinRoom(String chatId) async {
    _activeChatId = chatId;
    // Emit both variations to be compatible with server handlers
    _socket?.emit('chat:join', {'chatId': chatId});
    _socket?.emit('join', {'chatId': chatId});
  }

  @override
  Future<bool> sendMessage({
    required String chatId,
    required String content,
  }) async {
    // If not connected, fail fast
    if (!(_socket?.connected ?? false)) {
      // Debug: not connected when trying to send
      // print('Socket send failed: not connected');
      return false;
    }
  
    // Debug: sending payload
    // print('Emitting message:send -> chatId=$chatId content="$content"');
    _socket?.emit('message:send', {
      'chatId': chatId,
      'content': content,
      'type': 'text',
    });
    // Since we are not waiting for an acknowledgement, we assume success if the
    // message was emitted. The connection check at the start handles offline cases.
    return true;
  }

  @override
  Stream<Map<String, dynamic>> messages() => _messageCtrl.stream;

  @override
  // Stream<Map<String, dynamic>> typing() => _typingCtrl.stream;
  @override
  Future<void> disconnect() async {
    // Keep controllers open for reuse on reconnect
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _activeChatId = null;
  }
}
