import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
part 'auth_event.dart';
part 'auth_state.dart';

const String kLoginError = 'Login failed';
const String kLogoutError = 'Logout failed';
const String kSignupError = 'Signup failed';
const String kLoginSuccess = 'Login successful';
const String kLogoutSuccess = 'Logout successful';
const String kSignupSuccess = 'Signup successful';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase loginUsecase;
  final LogoutUsecase logoutUsecase;
  final SignUpUsecase signupUsecase;
  AuthBloc({
    required this.loginUsecase,
    required this.logoutUsecase,
    required this.signupUsecase,
  }) : super(Unauthenticated()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthSignupRequested>(_onSignupRequested);
    // on<AuthCheckRequested>(_onAuthCheckRequested);
  }
  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await loginUsecase.call(event.email, event.password);
    result.fold(
      (failure) => emit(AuthError(failure.messages)),
      (user) => emit(Authenticated()),
    );
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await logoutUsecase.call();
    result.fold(
      (failure) => emit(AuthError(failure.messages)),
      (confirmation) => emit(Unauthenticated(), ),
    );
  }

  Future<void> _onSignupRequested(
    AuthSignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await signupUsecase.call(
      event.name,
      event.email,
      event.password,
    );
    result.fold(
      (failure) => emit(AuthError(failure.messages)),
      (confirmation) => emit(Authenticated()),
    );
  }
}
