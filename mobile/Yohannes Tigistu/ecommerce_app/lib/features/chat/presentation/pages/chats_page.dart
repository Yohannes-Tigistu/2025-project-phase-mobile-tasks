import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../authentication/domain/repository/auth_repository.dart';
import '../../../authentication/domain/entities/user.dart';
import '../bloc/chat_bloc.dart';
import '../widgets/list_chats.dart';
import '../../domain/entities/chat.dart';
import 'specific_chat_page.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  static const double _headerHeightFrac = 0.27;
  static const double _cardTopOffsetFrac = 0.23;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<ChatBloc>();
    bloc
      ..add(const ChatGetUsers())
      ..add(const ChatGetChats());
  }

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
          final users = state is ChatOverview ? state.users : const <User>[];
          final chats = state is ChatOverview ? state.chats : const <Chat>[];

          return Stack(
            children: [
              Container(
                height: deviceHeight * _headerHeightFrac,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 21, 122, 135),
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: buildUserAvatars(users),
              ),
              Positioned(
                top: deviceHeight * _cardTopOffsetFrac,
                left: 0,
                right: 0,
                bottom: 0,
                child: Card(
                  margin: EdgeInsets.zero,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(70),
                    ),
                  ),
                  child: FutureBuilder(
                    future: context.read<AuthRepository>().getCurrentUser(),
                    builder: (context, snapshot) {
                      String? currentUserId;
                      if (snapshot.connectionState == ConnectionState.done &&
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
              if (state is ChatInitial)
                const Center(child: CircularProgressIndicator()),
            ],
          );
        },
      ),
    );
  }
}
