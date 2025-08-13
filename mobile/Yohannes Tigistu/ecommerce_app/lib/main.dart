import 'package:ecommerce_app/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/Products/presentation/pages/addproduct.dart';
import 'features/Products/presentation/pages/details.dart';
import 'features/Products/presentation/pages/home.dart';
import 'features/authentication/presentation/pages/sign_in_page.dart';
import 'features/authentication/presentation/pages/sign_up_page.dart';
import 'features/authentication/presentation/pages/splash_screen.dart';
import 'features/chat/presentation/pages/chats_page.dart';
import 'features/chat/presentation/pages/specific_chat_page.dart';
import 'features/chat/domain/entities/chat.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.setup();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: di.repositoryProviders,
      child: MultiBlocProvider(
        providers: di.blocProviders,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(),
          home: const SplashScreen(),
          routes: {
            '/signup': (context) => SignUpPage(),
            '/signin': (context) => SignIn(),
            '/home': (context) => MyHomePage(),
            '/chats': (context) => ChatsPage(),
            '/details': (context) => DetialsPage(),
            '/addproduct': (context) => Addproduct(),
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
