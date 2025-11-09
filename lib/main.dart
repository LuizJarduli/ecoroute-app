import 'package:eco_route_mobile_app/core/api/api_service.dart';
import 'package:eco_route_mobile_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:eco_route_mobile_app/features/auth/domain/repositories/token_repository.dart';
import 'package:eco_route_mobile_app/features/auth/domain/usecases/get_current_user.dart';
import 'package:eco_route_mobile_app/features/auth/domain/usecases/login.dart';
import 'package:eco_route_mobile_app/features/auth/domain/usecases/logout.dart';
import 'package:eco_route_mobile_app/features/auth/infrastructure/repositories/auth_repository_impl.dart';
import 'package:eco_route_mobile_app/features/auth/infrastructure/repositories/token_repository_impl.dart';
import 'package:eco_route_mobile_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:eco_route_mobile_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:eco_route_mobile_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:eco_route_mobile_app/features/auth/presentation/screens/login_screen.dart';
import 'package:eco_route_mobile_app/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(
          create: (_) => ApiService(),
        ),
        Provider<FlutterSecureStorage>(
          create: (_) => const FlutterSecureStorage(),
        ),
        Provider<TokenRepository>(
          create: (context) => TokenRepositoryImpl(
            secureStorage: context.read<FlutterSecureStorage>(),
          ),
        ),
        Provider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(
            apiService: context.read<ApiService>(),
            tokenRepository: context.read<TokenRepository>(),
          ),
        ),
        BlocProvider<AuthBloc>(
          create: (context) {
            final authRepository = context.read<AuthRepository>();
            return AuthBloc(
              login: Login(authRepository),
              getCurrentUser: GetCurrentUser(authRepository),
              logout: Logout(authRepository),
            )..add(AppStarted());
          },
        ),
      ],
      child: MaterialApp(
        title: 'EcoRoute',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return const HomeScreen();
            } else {
              return const LoginScreen();
            }
          },
        ),
      ),
    );
  }
}
