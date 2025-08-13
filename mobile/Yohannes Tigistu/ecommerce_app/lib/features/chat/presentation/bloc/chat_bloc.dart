import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../authentication/domain/entities/user.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';
import '../../domain/usecases/connect_usecase.dart';
import '../../domain/usecases/disconnect_usecase.dart';
import '../../domain/usecases/get_chats_usecase.dart';
import '../../domain/usecases/get_users_usecase.dart';
import '../../domain/usecases/initiat_chat_usecase.dart';
import '../../domain/usecases/join_room_usecase.dart';
import '../../domain/usecases/messages_usecase.dart';
import '../../domain/usecases/observe_messages_usecase.dart';
import '../../domain/usecases/send_message_usecase.dart';
import '../../domain/repository/chat_repository.dart';

part 'chat_event.dart';
part 'chat_state.dart';

const String kChatConnected = 'Chat connected';
const String kChatConnectedErrorMessage = 'Failed to connect to chat';
const String kChatJoinErrorMessage = 'Failed to join chat';
const String kChatSendErrorMessage = 'Failed to send message';
const String kChatDisconnectErrorMessage = 'Failed to disconnect from chat';
const String kChatGetUsersErrorMessage = 'Failed to get users';
const String kChatGetChatsErrorMessage = 'Failed to get chats';
const String kChatGetMessagesErrorMessage = 'Failed to get messages';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ConnectUsecase connectUsecase;
  final JoinRoomUsecase joinRoomUsecase;
  final ObserveMessagesUsecase observeMessagesUsecase;
  final SendMessageUsecase sendMessageUsecase;
  final DisconnectUsecase disconnectUsecase;
  final GetChatsUsecase getChatsUsecase;
  final GetUsersUsecase getUsersUsecase;
  final MessagesUsecase messagesUsecase;
  final ChatRepository chatRepository;
  final InitiateChatUsecase initiateChatUsecase;

  StreamSubscription<Message>? _messagesSub;

  ChatBloc({
    required this.connectUsecase,
    required this.joinRoomUsecase,
    required this.observeMessagesUsecase,
    required this.getChatsUsecase,
    required this.getUsersUsecase,
    required this.sendMessageUsecase,
    required this.initiateChatUsecase,
    required this.messagesUsecase,
    required this.chatRepository,

    required this.disconnectUsecase,
  }) : super(ChatInitial()) {
    on<ChatConnect>(_onConnect);
    on<ChatJoinRoom>(_onJoin);
    on<ChatSendMessage>(_onSend);
    on<ChatDisconnect>(_onDisconnect);
    on<_ChatIncoming>(_onIncoming);
    on<ChatErrorOccurred>(_onErrorOccurred);
    on<ChatGetChats>(_onGetChats);
    on<ChatGetUsers>(_onGetUsers);
    on<GetChatMessages>(_onGetChatMessages);

    // Register socket listeners to drive Bloc updates
    chatRepository.setListeners(
      onConnected: () {
        // Optionally reflect connection state
        // add a ChatConnect event? Not needed; we emit in _onConnect
      },
      onDisconnected: () {
        // Optionally reflect disconnection
        // emit(ChatInitial());
      },
      onMessageReceived: (msg) {
        add(_ChatIncoming(msg));
      },
      onMessageDelivered: (msg) {
        // Treat delivery similar to receive so UI updates, can be refined later
        add(_ChatIncoming(msg));
      },
      onMessageError: (err) {
        // Dispatch dedicated error event instead of calling emit here
        add(ChatErrorOccurred(err));
      },
    );
  }

  Future<void> _onConnect(ChatConnect event, Emitter<ChatState> emit) async {
    print('ChatBloc: _onConnect called');
    emit(ChatLoading());
    final res = await connectUsecase();
    res.fold(
      (l) {
        print('ChatBloc: _onConnect failed with error: $l');
        emit(ChatError(l.toString()));
      },
      (r) {
        print('ChatBloc: _onConnect succeeded');
        emit(ChatConnected());
      },
    );
  }

  void _onErrorOccurred(ChatErrorOccurred event, Emitter<ChatState> emit) {
    print('ChatBloc: socket error occurred: ${event.error}');
    emit(ChatError(event.error));
  }

  Future<void> _onJoin(ChatJoinRoom event, Emitter<ChatState> emit) async {
    print('ChatBloc: _onJoin called with chatId: ${event.chatId}');
    emit(ChatLoading());
    final res = await joinRoomUsecase(event.chatId);
    await _messagesSub?.cancel();
    _messagesSub = observeMessagesUsecase().listen((msg) {
      print('ChatBloc: Incoming message: $msg');
      add(_ChatIncoming(msg));
    });
    res.fold(
      (l) {
        print('ChatBloc: _onJoin failed with error: $l');
        emit(ChatError(l.toString()));
      },
      (r) {
        print('ChatBloc: _onJoin succeeded');
        emit(ChatJoined(event.chatId));
      },
    );
  }

  Future<void> _onSend(ChatSendMessage event, Emitter<ChatState> emit) async {
    debugPrint('ChatBloc: _onSend called with message: ${event.message}');
    final res = await sendMessageUsecase.sendMessage(event.message);
    res.fold(
      (l) {
        print('ChatBloc: _onSend failed with error: $l');
        emit(ChatError(l.toString()));
      },
      (r) {
        print('ChatBloc: _onSend succeeded');
        // Optimistically append the message so the UI updates instantly
        add(_ChatIncoming(event.message));
      },
    );
  }

  void _onIncoming(_ChatIncoming event, Emitter<ChatState> emit) {
    print('ChatBloc: _onIncoming called with message: ${event.message}');
    final current = state;
    if (current is ChatMessagesUpdated) {
      final updated = List<Message>.from(current.messages)..add(event.message);
      emit(ChatMessagesUpdated(updated));
    } else {
      emit(ChatMessagesUpdated([event.message]));
    }
  }

  Future<void> _onDisconnect(
    ChatDisconnect event,
    Emitter<ChatState> emit,
  ) async {
    print('ChatBloc: _onDisconnect called');
    await _messagesSub?.cancel();
    await disconnectUsecase.disconnect();
    emit(ChatInitial());
  }

  @override
  Future<void> close() {
    print('ChatBloc: close called');
    _messagesSub?.cancel();
    return super.close();
  }

  Future<void> _onGetChats(ChatGetChats event, Emitter<ChatState> emit) async {
    print('ChatBloc: _onGetChats called');
    final res = await getChatsUsecase.getChats();
    res.fold(
      (l) {
        print('ChatBloc: _onGetChats failed with error: $l');
        emit(const ChatError(kChatGetChatsErrorMessage));
      },
      (chats) {
        print('ChatBloc: _onGetChats succeeded with chats: $chats');
        final current = state;
        if (current is ChatOverview) {
          emit(ChatOverview(users: current.users, chats: chats));
        } else {
          emit(ChatOverview(users: const [], chats: chats));
        }
      },
    );
  }

  Future<void> _onGetUsers(ChatGetUsers event, Emitter<ChatState> emit) async {
    print('ChatBloc: _onGetUsers called');
    final res = await getUsersUsecase.getUsers();
    res.fold(
      (l) {
        print('ChatBloc: _onGetUsers failed with error: $l');
        emit(const ChatError(kChatGetUsersErrorMessage));
      },
      (users) {
        print('ChatBloc: _onGetUsers succeeded with users: $users');
        final current = state;
        if (current is ChatOverview) {
          emit(ChatOverview(users: users, chats: current.chats));
        } else {
          emit(ChatOverview(users: users, chats: const []));
        }
      },
    );
  }

  Future<void> _onGetChatMessages(
    GetChatMessages event,
    Emitter<ChatState> emit,
  ) async {
    print('ChatBloc: _onGetChatMessages called with chatId: ${event.chatId}');
    final res = await messagesUsecase.messages(event.chatId);
    res.fold(
      (l) {
        print('ChatBloc: _onGetChatMessages failed with error: $l');
        emit(const ChatError(kChatGetMessagesErrorMessage));
      },
      (messages) {
        print(
          'ChatBloc: _onGetChatMessages succeeded with messages: $messages',
        );
        emit(ChatMessagesUpdated(messages));
      },
    );
  }

  // Call this from the ShowDialog (e.g. after user selects a person to chat with)
  // Example: context.read<ChatBloc>().initiateChatFromDialog(selectedUser.id);
  Future<void> initiateChatFromDialog(String userId) async {
    print('ChatBloc: initiateChatFromDialog called with user: $userId');
    final res = await initiateChatUsecase.initiateChat(userId);
    res.fold(
      (l) {
        print('ChatBloc: initiateChatFromDialog failed with error: $l');
        add(ChatErrorOccurred(l.toString()));
      },
      (chat) {
        print('ChatBloc: initiateChatFromDialog succeeded with chat: $chat');
        add(ChatJoinRoom(chat.chatId));
      },
    );
  }
}
