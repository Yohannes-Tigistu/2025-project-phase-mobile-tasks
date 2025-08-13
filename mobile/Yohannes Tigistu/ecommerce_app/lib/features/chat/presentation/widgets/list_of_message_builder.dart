// A builder for the list of messages in the chat
import 'package:flutter/widgets.dart';

import '../../../authentication/domain/entities/user.dart';
import '../../domain/entities/message.dart';
import 'message_widget.dart';

class MessageListBuilder extends StatelessWidget {
  const MessageListBuilder({
    super.key,
    required this.messages,
    required this.user,
    required this.scrollController,
  });

  final List<Message> messages;
  final User user;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      reverse: true,
      physics: const BouncingScrollPhysics(),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        return Align(
          alignment: msg.sender.id == user.id
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: MessageWidget(message: msg, user: user),
        );
      },
    );
  }
}