import 'package:eco_route_mobile_app/features/auth/presentation/screens/login_screen.dart';
import 'package:eco_route_mobile_app/features/home/presentation/screens/home_screen.dart';
import 'package:eco_route_mobile_app/features/splash/presentation/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
