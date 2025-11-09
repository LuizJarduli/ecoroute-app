import 'package:bloc/bloc.dart';
import 'package:eco_route_mobile_app/core/usecases/usecase.dart';
import 'package:eco_route_mobile_app/features/auth/domain/usecases/get_current_user.dart';
import 'package:eco_route_mobile_app/features/auth/domain/usecases/login.dart';
import 'package:eco_route_mobile_app/features/auth/domain/usecases/logout.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetCurrentUser getCurrentUser;
  final Login login;
  final Logout logout;

  AuthBloc({
    required this.getCurrentUser,
    required this.login,
    required this.logout,
  }) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
  }

  void _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    final failureOrUser = await getCurrentUser(NoParams());
    emit(failureOrUser.fold(
      (failure) => AuthUnauthenticated(),
      (user) => AuthAuthenticated(user!),
    ));
  }

  void _onLoggedIn(LoggedIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final failureOrUser = await login(LoginParams(email: event.email, password: event.password));
    emit(failureOrUser.fold(
      (failure) => const AuthFailure('Invalid credentials'),
      (user) => AuthAuthenticated(user),
    ));
  }

  void _onLoggedOut(LoggedOut event, Emitter<AuthState> emit) async {
    await logout(NoParams());
    emit(AuthUnauthenticated());
  }
}
