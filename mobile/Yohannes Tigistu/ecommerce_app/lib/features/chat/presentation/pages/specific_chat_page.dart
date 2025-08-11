import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../authentication/domain/entities/user.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';
import '../bloc/chat_bloc.dart';
import '../widgets/list_of_message_builder.dart';
import '../widgets/message_inputer.dart';
import '../widgets/message_widget.dart';

class SpecificChatPage extends StatefulWidget {
  const SpecificChatPage({super.key, required this.chat});

  final Chat chat;

  @override
  State<SpecificChatPage> createState() => _SpecificChatPageState();
}

class _SpecificChatPageState extends State<SpecificChatPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    // Disconnect socket when leaving the chat room
    context.read<ChatBloc>().add(const ChatDisconnect());
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Connect to socket, join this chat room, and get initial messages
    context.read<ChatBloc>()
      ..add(const ChatConnect())
      ..add(ChatJoinRoom(widget.chat.chatId))
      ..add(GetChatMessages(widget.chat.chatId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: Colors.indigo,
              child: Text(
                widget.chat.user2.name[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 8),
            Text(widget.chat.user2.name),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.phone_outlined, size: 27),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.videocam_outlined, size: 30),
          ),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatMessagesUpdated) {
                  final messages = state.messages
                      .where((msg) => msg.chat.chatId == widget.chat.chatId)
                      .toList();
                  if (messages.isEmpty) {
                    return const Center(child: Text('No messages yet'));
                  }
                  return MessageListBuilder(
                    messages: messages,
                    user: widget.chat.user1,
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
          MessageInputBar(
            controller: _controller,
            onSend: (text) {
              if (text.trim().isEmpty) return;
              final msg = Message(
                id: UniqueKey().toString(),
                chat: widget.chat,
                sender: User(
                  id: '6895138587b81e087f98245d', // optionally fill with current user id
                  name: 'cheif',
                  email: 'chief@gmail.com',
                ),
                content: text.trim(),
                timestamp: DateTime.now(),
              );
              context.read<ChatBloc>().add(ChatSendMessage(msg));
              _controller.clear();
            },
          ),
        ],
      ),
    );
  }
}
