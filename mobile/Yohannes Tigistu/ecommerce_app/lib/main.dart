import 'package:ecommerce_app/core/network/network_info.dart';
import 'package:ecommerce_app/features/authentication/data/datasources/auth_local_data_source.dart';
import 'package:ecommerce_app/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/Products/presentation/pages/home_page.dart';
import 'features/authentication/data/repository/auth_repository_impl.dart';
import 'features/authentication/domain/repository/auth_repository.dart';
import 'features/authentication/domain/usecases/login_usecase.dart';
import 'features/authentication/domain/usecases/logout_usecase.dart';
import 'features/authentication/domain/usecases/sign_up_usecase.dart';
import 'features/authentication/presentation/bloc/auth_bloc.dart';
import 'features/authentication/presentation/pages/sign_in_page.dart';
import 'features/authentication/presentation/pages/sign_up_page.dart';
import 'features/authentication/presentation/pages/splash_screen.dart';
import 'features/chat/data/datasources/chat_remote_data_source.dart';
import 'features/chat/data/datasources/chat_socket_data_source.dart';
import 'features/chat/data/repository/chat_repository_impl.dart';
import 'features/chat/domain/usecases/connect_usecase.dart';
import 'features/chat/domain/usecases/disconnect_usecase.dart';
import 'features/chat/domain/usecases/initiat_chat_usecase.dart';
import 'features/chat/domain/usecases/join_room_usecase.dart';
import 'features/chat/domain/usecases/messages_usecase.dart';
import 'features/chat/domain/usecases/observe_messages_usecase.dart';
import 'features/chat/domain/usecases/send_message_usecase.dart';
import 'features/chat/domain/usecases/get_chats_usecase.dart';
import 'features/chat/domain/usecases/get_users_usecase.dart';
import 'features/chat/presentation/bloc/chat_bloc.dart';
import 'features/chat/presentation/pages/chats_page.dart';
import 'features/chat/presentation/pages/specific_chat_page.dart';
import 'features/chat/domain/entities/chat.dart';

// Uncomment and adjust these when you add more blocs
// import 'features/Products/presentation/bloc/products_bloc.dart';
// import 'features/chat/presentation/bloc/chat_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();

  final authRepository = AuthRepositoryImpl(
    remoteDataSource: AuthRemoteDataSourceImpl(client: http.Client()),
    localDataSource: AuthLocalDataSourceImpl(
      sharedPreferences: sharedPreferences,
    ),
    networkInfo: NetworkInfoImpl(InternetConnection()),
  );

  runApp(
    MyApp(authRepository: authRepository, sharedPreferences: sharedPreferences),
  );
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;
  final SharedPreferences sharedPreferences;
  const MyApp({
    super.key,
    required this.authRepository,
    required this.sharedPreferences,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(value: authRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              loginUsecase: LoginUsecase(authRepository),
              logoutUsecase: LogoutUsecase(authRepository),
              signupUsecase: SignUpUsecase(authRepository),
            ),
          ),
          // Chat feature bloc
          BlocProvider<ChatBloc>(
            create: (context) {
              final chatRepository = ChatRepositoryImpl(
                remoteDataSource: ChatRemoteDataSourceImpl(
                  client: http.Client(),
                ),
                socketDataSource: ChatSocketDataSourceImpl(),
                networkInfo: NetworkInfoImpl(InternetConnection()),
                sharedPreferences: sharedPreferences,
              );
              return ChatBloc(
                connectUsecase: ConnectUsecase(chatRepository),
                joinRoomUsecase: JoinRoomUsecase(chatRepository),
                observeMessagesUsecase: ObserveMessagesUsecase(chatRepository),
                getChatsUsecase: GetChatsUsecase(chatRepository),
                getUsersUsecase: GetUsersUsecase(chatRepository),
                sendMessageUsecase: SendMessageUsecase(chatRepository),
                disconnectUsecase: DisconnectUsecase(chatRepository),
                messagesUsecase: MessagesUsecase(chatRepository),
                chatRepository: chatRepository,
                initiateChatUsecase: InitiateChatUsecase(chatRepository),
              );
            },
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(),
          home: const SplashScreen(),
          routes: {
            '/signup': (context) => SignUpPage(),
            '/signin': (context) => SignIn(),
            '/home': (context) => HomePage(),
            '/chats': (context) => ChatsPage(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/specific_chat') {
              final args = settings.arguments;
              if (args is Chat) {
                return MaterialPageRoute(
                  builder: (_) => SpecificChatPage(chat: args),
                );
              }
              return MaterialPageRoute(
                builder: (_) => const Scaffold(
                  body: Center(child: Text('Chat data not provided')),
                ),
              );
            }
            return null;
          },
        ),
      ),
    );
  }
}
