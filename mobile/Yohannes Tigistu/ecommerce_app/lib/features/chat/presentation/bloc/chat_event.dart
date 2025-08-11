part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class ChatConnect extends ChatEvent {
  const ChatConnect();
}

class ChatJoinRoom extends ChatEvent {
  final String chatId;
  const ChatJoinRoom(this.chatId);

  @override
  List<Object> get props => [chatId];
}

class ChatSendMessage extends ChatEvent {
  final Message message;
  const ChatSendMessage(this.message);

  @override
  List<Object> get props => [message];
}

class ChatGetChats extends ChatEvent {
  const ChatGetChats();
}

class ChatGetUsers extends ChatEvent {
  const ChatGetUsers();
}

class GetChatMessages extends ChatEvent {
  final String chatId;
  const GetChatMessages(this.chatId);

  @override
  List<Object> get props => [chatId];
}

class ChatDisconnect extends ChatEvent {
  const ChatDisconnect();
}

// Internal event for messages coming from the socket stream
class _ChatIncoming extends ChatEvent {
  final Message message;
  const _ChatIncoming(this.message);

  @override
  List<Object> get props => [message];
}

// Internal event to surface socket errors without calling emit from constructor callbacks
class ChatErrorOccurred extends ChatEvent {
  final String error;
  const ChatErrorOccurred(this.error);

  @override
  List<Object> get props => [error];
}
// Initiate a chat with a new user:
class ChatStartChat extends ChatEvent {
  final User user;
  const ChatStartChat({required this.user});

  @override
  List<Object> get props => [user];
}
