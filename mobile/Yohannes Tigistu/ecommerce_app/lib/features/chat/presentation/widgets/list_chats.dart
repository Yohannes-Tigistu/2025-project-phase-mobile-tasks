import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../authentication/domain/entities/user.dart';
import '../../../authentication/presentation/widgets/text.dart';
import '../../domain/entities/chat.dart';
import '../bloc/chat_bloc.dart';
import '../pages/specific_chat_page.dart';

Widget buildChatsList(
  List<Chat> chats, {
  String? currentUserId,
  void Function(Chat chat)? onTap,
}) {
  if (chats.isEmpty) {
    return const Center(child: Text('No chats yet'));
  }

  return ListView.separated(
    itemCount: chats.length,
    separatorBuilder: (_, __) => const Divider(height: 1),
    itemBuilder: (context, index) {
      final chat = chats[index];
      final otherName = currentUserId == null
          ? '${chat.user1.name} • ${chat.user2.name}'
          : (chat.user1.id == currentUserId
                ? chat.user2.name
                : chat.user1.name);

      return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          radius: 30,
          child: Text(otherName.isNotEmpty ? otherName[0].toUpperCase() : '?'),
        ),
        title: Text(otherName, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.grey[600]),
        ),
        onTap: onTap == null ? null : () => onTap(chat),
      );
    },
  );
}

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
            showDialog(
              context: context,
              builder: (dialogCtx) {
                bool loading = false;

                Future<void> start(BuildContext c) async {
                  if (loading) return;
                  loading = true;
                  c.findRootAncestorStateOfType<State>()?.setState(() {});
                  final bloc = context.read<ChatBloc>();
                  bloc.add(ChatStartChat(user: user));
                  Navigator.of(c).pop(); // close dialog
                  // wait for the chat creation success state
                  final successState =
                      await bloc.stream.firstWhere(
                            (s) =>
                                s is ChatStartSuccess &&
                                ((s.chat.user1.id == user.id) ||
                                    (s.chat.user2.id == user.id)),
                          )
                          as ChatStartSuccess;
                  if (!context.mounted) return;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SpecificChatPage(chat: successState.chat),
                    ),
                  );
                }

                return StatefulBuilder(
                  builder: (c, setState) => AlertDialog(
                    title: const Text('Initiate Chat'),
                    content: RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(c).style,
                        children: <TextSpan>[
                          const TextSpan(
                            text: 'Do you want to initiate chat with ',
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: user.name.toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const TextSpan(
                            text: '?',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: loading ? null : () => start(c),
                        child: loading
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Yes'),
                      ),
                      TextButton(
                        onPressed: loading
                            ? null
                            : () {
                                Navigator.of(c).pop();
                              },
                        child: const Text('No'),
                      ),
                    ],
                  ),
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
                  backgroundColor: Colors.blue[100],
                  radius: 25,
                  child: Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  user.name
                      .split(' ')[0]
                      .substring(0, user.name.split(' ')[0].length.clamp(0, 4)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.body.copyWith(
                    color: Colors.black87,
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
