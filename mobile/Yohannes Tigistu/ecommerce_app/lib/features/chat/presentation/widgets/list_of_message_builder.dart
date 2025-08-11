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
  });

  final List<Message> messages;
  final User user;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 9,
      ),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        // Use MessageWidget to display each message
        // each messagewidget will be aligned based on the sender
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
