import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../authentication/domain/entities/user.dart';
import '../../../authentication/domain/repository/auth_repository.dart';
import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';
import '../bloc/chat_bloc.dart';
import '../widgets/list_of_message_builder.dart';
import '../widgets/message_inputer.dart';

class SpecificChatPage extends StatefulWidget {
  const SpecificChatPage({super.key, required this.chat});

  final Chat chat;

  @override
  State<SpecificChatPage> createState() => _SpecificChatPageState();
}

class _SpecificChatPageState extends State<SpecificChatPage> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    context.read<ChatBloc>().add(const ChatDisconnect());
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>()
      ..add(const ChatConnect())
      ..add(ChatJoinRoom(widget.chat.chatId))
      ..add(GetChatMessages(widget.chat.chatId));
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (!didPop) return;
        context.read<ChatBloc>().add(const ChatDisconnect());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.blue[300],
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
                    _scrollToBottom();
                    return MessageListBuilder(
                      messages: messages,
                      user: widget.chat.user1,
                      scrollController: _scrollController,
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
                final repo = context.read<AuthRepository>();
                repo.getCurrentUser().then((either) {
                  either.fold(
                    (failure) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Failed to get current user'),
                          ),
                        );
                      }
                    },
                    (currentUser) {
                      if (!mounted) return;
                      final msg = Message(
                        id: UniqueKey().toString(),
                        chat: widget.chat,
                        sender: currentUser,
                        content: text.trim(),
                        timestamp: DateTime.now(),
                      );
                      context.read<ChatBloc>().add(ChatSendMessage(msg));
                      _scrollToBottom();
                    },
                  );
                });
                _controller.clear();
              },
            ),
          ],
        ),
      ),
    );
  }
}
