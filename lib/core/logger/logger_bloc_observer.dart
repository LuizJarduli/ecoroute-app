import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eco_route_mobile_app/core/logger/logger.dart';

class LoggerBlocObserver extends BlocObserver {
  final Logger logger;

  LoggerBlocObserver(this.logger);

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    logger.log('${bloc.runtimeType} { event: $event }');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    logger.log('${bloc.runtimeType} { transition: $transition }');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    logger.error('${bloc.runtimeType} { error: $error }', error, stackTrace);
  }
}
