part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object> get props => [];
}


final class Unauthenticated extends AuthState {}
final class AuthLoading extends AuthState {}
final class Authenticated extends AuthState {
}
final class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object> get props => [message];
}
