import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../authentication/domain/entities/user.dart';
import '../../domain/entities/message.dart';

// a single instance of a message for the ui
class MessageWidget extends StatelessWidget {
  const MessageWidget({super.key, required this.message, required this.user});

  final Message message;
  final User user;

  String _formatTimestamp(DateTime timestamp) {
    // am pm
    final hour = timestamp.hour;
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final ampm = hour >= 12 ? 'PM' : 'AM';
    return '${hour % 12}:${minute} $ampm';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.black12,
      color: user.id == message.sender.id ? Colors.blue[100] : Colors.grey[300],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      // based onthe user id choos a side to stick to left or th right
      child: Column(
        crossAxisAlignment: user.id == message.sender.id
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment(1, 1),
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(message.content),
              ),
              Text(_formatTimestamp(message.timestamp)),
            ],
          ),
        ],
      ),
    );
  }
}
