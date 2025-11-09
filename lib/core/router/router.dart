import 'dart:async';

import 'package:eco_route_mobile_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:eco_route_mobile_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:eco_route_mobile_app/features/auth/presentation/screens/login_screen.dart';
import 'package:eco_route_mobile_app/features/home/presentation/screens/home_screen.dart';
import 'package:eco_route_mobile_app/features/home/presentation/screens/main_navigation_shell.dart';
import 'package:eco_route_mobile_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:eco_route_mobile_app/features/splash/presentation/screens/splash_screen.dart';
import 'package:eco_route_mobile_app/features/tickets/presentation/screens/tickets_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AuthRefreshNotifier extends ChangeNotifier {
  AuthRefreshNotifier(AuthBloc authBloc) {
    _authBlocSubscription = authBloc.stream.listen((_) {
      notifyListeners();
    });
  }

  StreamSubscription<AuthState>? _authBlocSubscription;

  @override
  void dispose() {
    _authBlocSubscription?.cancel();
    super.dispose();
  }
}

GoRouter createRouter(
  BuildContext context,
  AuthRefreshNotifier refreshNotifier,
) {
  return GoRouter(
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final authBloc = context.read<AuthBloc>();
      final authState = authBloc.state;
      final path = state.uri.path;
      final isGoingToLogin = path == '/login';
      final isGoingToMainNav =
          path.startsWith('/home') ||
          path.startsWith('/tickets') ||
          path.startsWith('/profile');
      final isGoingToRoot = path == '/';

      // Handle initial/loading state
      if (authState is AuthInitial || authState is AuthLoading) {
        if (!isGoingToRoot) {
          return '/';
        }
        return null;
      }

      // Handle authenticated state
      if (authState is AuthAuthenticated) {
        if (isGoingToLogin || isGoingToRoot) {
          return '/home';
        }
        return null;
      }

      // Handle unauthenticated state
      if (authState is AuthUnauthenticated || authState is AuthFailure) {
        if (isGoingToMainNav || isGoingToRoot) {
          return '/login';
        }
        return null;
      }

      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      ShellRoute(
        builder: (context, state, child) {
          return MainNavigationShell(location: state.uri.path, child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/tickets',
            builder: (context, state) => const TicketsScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
}
