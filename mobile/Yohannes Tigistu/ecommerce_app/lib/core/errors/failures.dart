import 'package:equatable/equatable.dart';

abstract class Failures extends Equatable {

  final String messages;
  
  
  const Failures(this.messages);
  
  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failures {
  ServerFailure(String message) : super(message);

  @override
  List<Object?> get props => [messages];
}

class CacheFailure extends Failures {
  CacheFailure(String message) : super(message);

  @override
  List<Object?> get props => [messages];
}

class NetworkFailure extends Failures {
  NetworkFailure(String message) : super(message);

  @override
  List<Object?> get props => [messages  ];
}
class AuthenticationFailure extends Failures {
  AuthenticationFailure(String message) : super(message);

  @override
  List<Object?> get props => [];
}

  
