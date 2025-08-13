import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../authentication/domain/entities/user.dart';
import '../../domain/entities/message.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({super.key, required this.message, required this.user});

  final Message message;
  final User user;

  String _formatTimestamp(DateTime timestamp) {
    final hour = timestamp.hour;
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final ampm = hour >= 12 ? 'PM' : 'AM';
    return '${hour % 12}:$minute $ampm';
  }

  @override
  Widget build(BuildContext context) {
    final isMe = user.id == message.sender.id;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: BoxDecoration(
              color: isMe ? Colors.blue[300] : Colors.grey[300],
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(12),
            child: Text(
              message.content,
              style: TextStyle(color: isMe ? Colors.white : Colors.black87),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatTimestamp(message.timestamp),
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}