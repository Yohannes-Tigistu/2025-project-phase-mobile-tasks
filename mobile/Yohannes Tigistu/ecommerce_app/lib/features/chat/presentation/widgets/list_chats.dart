import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../authentication/domain/entities/user.dart';
import '../../../authentication/presentation/widgets/text.dart';
import '../../domain/entities/chat.dart';
import '../bloc/chat_bloc.dart';
import '../pages/specific_chat_page.dart';

/// Builds a scrollable chat list from repository-provided Chat entities.
/// Optionally pass the currentUserId to display the "other" participant's name.
/// Provide onTap to handle navigation to a chat room.
Widget buildChatsList(
  List<Chat> chats, {
  String? currentUserId,
  void Function(Chat chat)? onTap,
}) {
  if (chats.isEmpty) {
    return const Center(child: Text('No chats yet'));
  }
  // get the current user and compare with chat participants

  return ListView.separated(
    itemCount: chats.length,
    separatorBuilder: (_, __) => const Divider(height: 1),
    itemBuilder: (context, index) {
      final chat = chats[index];
      // Derive a display name: show the other participant if we know the current user
      final otherName = currentUserId == null
          ? '${chat.user1.name} • ${chat.user2.name}'
          : (chat.user1.id == currentUserId
                ? chat.user2.name
                : chat.user1.name);

      return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: const Color.fromARGB(255, 221, 199, 199),
          radius: 30,
          child: Text(otherName.isNotEmpty ? otherName[0].toUpperCase() : '?'),
        ),
        title: Text(otherName, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          'Chat ID: ${chat.chatId}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        onTap: onTap == null ? null : () => onTap(chat),
      );
    },
  );
}

// HORIZONTAL LIST OF USERS LIST SHOWING AVATARS
Widget buildUserAvatars(List<User> users) {
  return SizedBox(
    height: 70,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: users.length,
      separatorBuilder: (_, __) => const SizedBox(width: 8),
      itemBuilder: (context, index) {
        final user = users[index];
        return InkWell(
          onTap: () {
            // Handle user tap
            // show an alert pop up saying do you want to initiate chat with ${user.name}?
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Initiate Chat'),
                  content: RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Do you want to initiate chat with ',
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: '${user.name}?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        // Handle chat initiation
                        context.read<ChatBloc>().add(ChatStartChat(user: user));
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SpecificChatPage(
                              chat: Chat(
                                chatId: '',
                                user1: user,
                                user2: User(id: '', name: '', email: ''),
                              ),
                            ),
                          ),
                        );
                      },
                      child: Text('Yes'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('No'),
                    ),
                  ],
                );
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 221, 199, 199),
                  radius: 25,
                  child: Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  user.name
                      .split(' ')[0]
                      .substring(0, user.name.split(' ')[0].length.clamp(0, 4))
                      .replaceFirst(
                        user.name.isNotEmpty ? user.name[0] : '',
                        user.name.isNotEmpty ? user.name[0].toUpperCase() : '',
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.body.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
