import 'package:eco_route_mobile_app/core/api/api_service.dart';
import 'package:eco_route_mobile_app/core/env/env.dart';
import 'package:eco_route_mobile_app/core/l10n/app_strings.dart';
import 'package:eco_route_mobile_app/core/logger/logger.dart';
import 'package:eco_route_mobile_app/core/logger/logger_bloc_observer.dart';
import 'package:eco_route_mobile_app/core/logger/logger_factory.dart';
import 'package:eco_route_mobile_app/core/router/router.dart';
import 'package:eco_route_mobile_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:eco_route_mobile_app/features/auth/domain/repositories/token_repository.dart';
import 'package:eco_route_mobile_app/features/auth/domain/usecases/get_current_user.dart';
import 'package:eco_route_mobile_app/features/auth/domain/usecases/login.dart';
import 'package:eco_route_mobile_app/features/auth/domain/usecases/logout.dart';
import 'package:eco_route_mobile_app/features/auth/infrastructure/repositories/auth_repository_impl.dart';
import 'package:eco_route_mobile_app/features/auth/infrastructure/repositories/token_repository_impl.dart';
import 'package:eco_route_mobile_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:eco_route_mobile_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  final Logger logger = LoggerFactory.createImplementation();
  Bloc.observer = LoggerBlocObserver(logger);
  runApp(MyApp(logger: logger));
}

class MyApp extends StatefulWidget {
  final Logger logger;
  const MyApp({super.key, required this.logger});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthRefreshNotifier? _authRefreshNotifier;
  GoRouter? _router;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        RepositoryProvider<Logger>(create: (_) => widget.logger),
        RepositoryProvider<ApiService>(
          create: (_) => ApiService(
            Env.getInstance(),
            LoggerFactory.createImplementation(),
          ),
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
      child: Builder(
        builder: (context) {
          // Initialize refresh notifier and router once after providers are available
          _authRefreshNotifier ??= AuthRefreshNotifier(
            context.read<AuthBloc>(),
          );
          _router ??= createRouter(context, _authRefreshNotifier!);

          return MaterialApp.router(
            title: AppStrings.appTitle,
            theme: ThemeData(
              primarySwatch: Colors.green,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            routerConfig: _router!,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _authRefreshNotifier?.dispose();
    super.dispose();
  }
}
