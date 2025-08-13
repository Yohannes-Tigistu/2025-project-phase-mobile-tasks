part of 'chat_bloc.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

final class ChatInitial extends ChatState {}

final class ChatLoading extends ChatState {}

final class ChatConnected extends ChatState {}

final class ChatJoined extends ChatState {
  final String chatId;
  const ChatJoined(this.chatId);

  @override
  List<Object> get props => [chatId];
}

final class ChatMessagesUpdated extends ChatState {
  final List<Message> messages;
  const ChatMessagesUpdated(this.messages);

  @override
  List<Object> get props => [messages];
}
final class ChatStartSuccess extends ChatState {
  final Chat chat;
  const ChatStartSuccess(this.chat);

  @override
  List<Object> get props => [chat];
}

// Combined overview state so UI can show both users and chats together
final class ChatOverview extends ChatState {
  final List<User> users;
  final List<Chat> chats;
  const ChatOverview({this.users = const [], this.chats = const []});

  @override
  List<Object> get props => [users, chats];
}

final class ChatError extends ChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object> get props => [message];
}
