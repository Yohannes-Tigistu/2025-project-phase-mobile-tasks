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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();

  final authRepository = AuthRepositoryImpl(
    remoteDataSource: AuthRemoteDataSourceImpl(client: http.Client()),
    localDataSource: AuthLocalDataSourceImpl(sharedPreferences: sharedPreferences),
    networkInfo: NetworkInfoImpl(
      InternetConnection()
    ),
  );

  runApp(MyApp(authRepository: authRepository));
}

class MyApp extends StatelessWidget {
  final AuthRepository authRepository;
  const MyApp({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(
        loginUsecase: LoginUsecase(authRepository),
        logoutUsecase: LogoutUsecase(authRepository),
        signupUsecase: SignUpUsecase(authRepository),
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(),
        home: const SplashScreen(),
        routes: {
          '/signup': (context) => SignUpPage(),
          '/signin': (context) => SignIn(),
          '/home': (context) => HomePage(),
        },
      ),
    );
  }
}