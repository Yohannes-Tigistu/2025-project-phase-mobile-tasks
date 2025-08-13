import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;

import 'core/network/network_info.dart';
import 'features/Products/data/datasources/products_local_data_source.dart';
import 'features/Products/data/datasources/products_remote_data_source.dart';
import 'features/Products/data/repositories/product_repository_impl.dart';
import 'features/Products/domain/repositories/product_repository.dart';
import 'features/Products/domain/usecases/create_new_product_usecase.dart';
import 'features/Products/domain/usecases/delete_product_usecase.dart';
import 'features/Products/domain/usecases/update_product_usecase.dart';
import 'features/Products/domain/usecases/view_all_products_usecase.dart';
import 'features/Products/domain/usecases/view_specific_product_usecase.dart';
import 'features/Products/presentation/bloc/product_bloc.dart';
import 'features/authentication/data/datasources/auth_local_data_source.dart';
import 'features/authentication/data/datasources/auth_remote_data_source.dart';
import 'features/authentication/data/repository/auth_repository_impl.dart';
import 'features/authentication/domain/repository/auth_repository.dart';
import 'features/authentication/domain/usecases/login_usecase.dart';
import 'features/authentication/domain/usecases/logout_usecase.dart';
import 'features/authentication/domain/usecases/sign_up_usecase.dart';
import 'features/authentication/presentation/bloc/auth_bloc.dart';
import 'features/chat/data/datasources/chat_remote_data_source.dart';
import 'features/chat/data/datasources/chat_socket_data_source.dart';
import 'features/chat/data/repository/chat_repository_impl.dart';
import 'features/chat/domain/repository/chat_repository.dart';
import 'features/chat/domain/usecases/connect_usecase.dart';
import 'features/chat/domain/usecases/disconnect_usecase.dart';
import 'features/chat/domain/usecases/get_chats_usecase.dart';
import 'features/chat/domain/usecases/get_users_usecase.dart';
import 'features/chat/domain/usecases/initiat_chat_usecase.dart';
import 'features/chat/domain/usecases/join_room_usecase.dart';
import 'features/chat/domain/usecases/messages_usecase.dart';
import 'features/chat/domain/usecases/observe_messages_usecase.dart';
import 'features/chat/domain/usecases/send_message_usecase.dart';
import 'features/chat/presentation/bloc/chat_bloc.dart';

final sl = GetIt.instance;

Future<void> setup() async {
  //! Features : Authorization
  //bloc
  sl.registerFactory(
    () =>
        AuthBloc(loginUsecase: sl(), signupUsecase: sl(), logoutUsecase: sl()),
  );
  //uscasess
  sl.registerLazySingleton(() => LoginUsecase(sl()));
  sl.registerLazySingleton(() => LogoutUsecase(sl()));
  sl.registerLazySingleton(() => SignUpUsecase(sl()));
  //repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  // datasources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Features : products
  //bloc
  sl.registerFactory(
    () => ProductBloc(
      createNewProductUsecase: sl(),
      updateProductUsecase: sl(),
      deleteProductUsecase: sl(),
      viewAllProductsUsecase: sl(),
      getProductByIdUsecase: sl(),
    ),
  );
  //uscasess
  sl.registerLazySingleton(() => CreateNewProductUsecase(sl()));
  sl.registerLazySingleton(() => UpdateProductUsecase(sl()));
  sl.registerLazySingleton(() => DeleteProductUsecase(sl()));
  sl.registerLazySingleton(() => ViewAllProductsUsecase(sl()));
  sl.registerLazySingleton(() => ViewSpecificProductUsecase(sl()));

  // repositories

  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  // datasources
  sl.registerLazySingleton<ProductsRemoteDataSource>(
    () => ProductsRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<ProductsLocalDataSource>(
    () => ProductsLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Featues : Chats
  //bloc
  sl.registerFactory(
    () => ChatBloc(
      connectUsecase: sl(),
      joinRoomUsecase: sl(),
      observeMessagesUsecase: sl(),
      getChatsUsecase: sl(),
      getUsersUsecase: sl(),
      sendMessageUsecase: sl(),
      initiateChatUsecase: sl(),
      messagesUsecase: sl(),
      chatRepository: sl(),
      disconnectUsecase: sl(),
    ),
  );
  //uscasess
  sl.registerLazySingleton(() => ConnectUsecase(sl()));
  sl.registerLazySingleton(() => JoinRoomUsecase(sl()));
  sl.registerLazySingleton(() => ObserveMessagesUsecase(sl()));
  sl.registerLazySingleton(() => GetChatsUsecase(sl()));
  sl.registerLazySingleton(() => GetUsersUsecase(sl()));
  sl.registerLazySingleton(() => SendMessageUsecase(sl()));
  sl.registerLazySingleton(() => InitiateChatUsecase(sl()));
  sl.registerLazySingleton(() => MessagesUsecase(sl()));
  sl.registerLazySingleton(() => DisconnectUsecase(sl()));

  // repositores
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      remoteDataSource: sl(),
      socketDataSource: sl(),
      networkInfo: sl(),
      sharedPreferences: sl(),
    ),
  );
  //datasources
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<ChatSocketDataSource>(
    () => ChatSocketDataSourceImpl(),
  );

  //!core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //!External
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(
    () => IO.io(
      'http://your-server-url', // Replace with your server URL
      IO.OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Dart
          .setAuth({'token': 'YOUR_TOKEN_HERE'})
          .build(),
    ),
  );
}

List<RepositoryProvider> get repositoryProviders => [
  RepositoryProvider<AuthRepository>(create: (_) => sl<AuthRepository>()),
  RepositoryProvider<ProductRepository>(create: (_) => sl<ProductRepository>()),
  RepositoryProvider<ChatRepository>(create: (_) => sl<ChatRepository>()),
];

List<BlocProvider> get blocProviders => [
  BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
  BlocProvider<ProductBloc>(create: (_) => sl<ProductBloc>()),
  BlocProvider<ChatBloc>(create: (_) => sl<ChatBloc>()),
];
