import 'package:eco_route_mobile_app/core/api/api_service.dart';
import 'package:eco_route_mobile_app/core/env/env.dart';
import 'package:eco_route_mobile_app/core/logger/logger.dart';
import 'package:eco_route_mobile_app/core/logger/logger_bloc_observer.dart';
import 'package:eco_route_mobile_app/core/logger/logger_factory.dart';
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
  final Logger logger = LoggerFactory.createImplementation();
  Bloc.observer = LoggerBlocObserver(logger);
  runApp(MyApp(logger: logger,));
}

class MyApp extends StatelessWidget {
  final Logger logger;
  const MyApp({super.key, required this.logger});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        RepositoryProvider<Logger>(
          create: (_) => logger,
        ),
        RepositoryProvider<ApiService>(
          create: (_) => ApiService(Env.getInstance()),
        ),
        RepositoryProvider<FlutterSecureStorage>(
          create: (_) => const FlutterSecureStorage(),
        ),
        RepositoryProvider<TokenRepository>(
          create: (context) => TokenRepositoryImpl(
            secureStorage: context.read<FlutterSecureStorage>(),
          ),
        ),
        RepositoryProvider<AuthRepository>(
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
              logger: context.read<Logger>(),
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
