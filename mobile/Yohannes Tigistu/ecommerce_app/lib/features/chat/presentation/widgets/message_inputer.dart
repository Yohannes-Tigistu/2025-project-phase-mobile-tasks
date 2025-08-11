import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MessageInputBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSend;
  const MessageInputBar({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: const Border(top: BorderSide(color: Colors.black12)),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.send,
                minLines: 1,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Type a message',
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  isDense: true,
                  filled: true,
                ),
                onSubmitted: onSend,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => onSend(controller.text.trim()),
            ),
          ],
        ),
      ),
    );
  }
}
