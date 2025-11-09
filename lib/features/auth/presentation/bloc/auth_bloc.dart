import 'package:bloc/bloc.dart';
import 'package:eco_route_mobile_app/core/logger/logger.dart';
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
  final Logger logger;

  AuthBloc({
    required this.getCurrentUser,
    required this.login,
    required this.logout,
    required this.logger,
  }) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
  }

  void _onAppStarted(AppStarted event, Emitter<AuthState> emit) async {
    try {
      logger.log('Checking current user');
      final failureOrUser = await getCurrentUser(NoParams());
      emit(failureOrUser.fold(
        (failure) {
          logger.log('No user found, emitting AuthUnauthenticated');
          return AuthUnauthenticated();
        },
        (user) {
          logger.log('User found: ${user?.id}, emitting AuthAuthenticated');
          return AuthAuthenticated(user!);
        },
      ));
    } catch (e, s) {
      logger.error('Error in _onAppStarted', e, s);
      emit(AuthUnauthenticated());
    }
  }

  void _onLoggedIn(LoggedIn event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());
      logger.log('Attempting login for email: ${event.email}');
      final failureOrUser =
          await login(LoginParams(email: event.email, password: event.password));
      emit(failureOrUser.fold(
        (failure) {
          logger.error('Login failed', failure, StackTrace.current);
          return const AuthFailure('Invalid credentials');
        },
        (user) {
          logger.log('Login successful for user: ${user.id}');
          return AuthAuthenticated(user);
        },
      ));
    } catch (e, s) {
      logger.error('Error in _onLoggedIn', e, s);
      emit(const AuthFailure('An unexpected error occurred during login.'));
    }
  }

  void _onLoggedOut(LoggedOut event, Emitter<AuthState> emit) async {
    try {
      logger.log('Logging out user');
      await logout(NoParams());
      emit(AuthUnauthenticated());
    } catch (e, s) {
      logger.error('Error during logout', e, s);
      emit(AuthUnauthenticated());
    }
  }
}
