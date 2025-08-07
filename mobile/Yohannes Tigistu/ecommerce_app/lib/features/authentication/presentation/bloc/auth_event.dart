part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}
final class AuthCheckRequested extends AuthEvent {}
final class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
  @override
  List<Object> get props => [];
}
final class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;
  const AuthLoginRequested(this.email, this.password);
  @override
  List<Object> get props => [email, password];
}
final class AuthSignupRequested extends AuthEvent {
  final String email;
  final String name;
  final String password;
  const AuthSignupRequested(this.email, this.name, this.password);
  @override
  List<Object> get props => [email, name, password];
}