import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../authentication/domain/repository/auth_repository.dart';
import '../../../authentication/domain/entities/user.dart';
import '../bloc/chat_bloc.dart';
import '../widgets/list_chats.dart';
import '../../domain/entities/chat.dart';
import 'specific_chat_page.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is ChatInitial) {
            context.read<ChatBloc>()
              ..add(const ChatGetUsers())
              ..add(const ChatGetChats());
          }
          return Stack(
            alignment: Alignment(0.9, 0.9),
            children: [
              Column(
                children: [
                  Container(
                    height: deviceHeight * 0.27,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 111, 163, 240),
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: buildUserAvatars(
                      state is ChatOverview ? state.users : const <User>[],
                    ),
                  ),
                  Expanded(
                    child: Card(
                      margin: EdgeInsets.zero,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      child: FutureBuilder(
                        future: context.read<AuthRepository>().getCurrentUser(),
                        builder: (context, snapshot) {
                          final chats = state is ChatOverview
                              ? state.chats
                              : const <Chat>[];
                          String? currentUserId;
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            snapshot.data!.fold(
                              (_) {},
                              (u) => currentUserId = u.id,
                            );
                          }
                          return buildChatsList(
                            chats,
                            currentUserId: currentUserId,
                            onTap: (chat) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SpecificChatPage(chat: chat),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              IconButton(
                iconSize: 40,
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  context.read<ChatBloc>()
                    ..add(const ChatGetUsers())
                    ..add(const ChatGetChats());
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
