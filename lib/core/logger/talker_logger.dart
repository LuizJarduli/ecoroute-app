import 'package:talker_flutter/talker_flutter.dart';

import 'logger.dart';

/// {@macro franquia_logger}
///
/// A [Logger] implementation that uses the [TalkerFlutter] package.
class LoggerTalkerImpl extends Logger {
  factory LoggerTalkerImpl.getInstance() {
    if (_instance == null) {
      _instance = LoggerTalkerImpl._internal();
      _talker = TalkerFlutter.init();
    }
    return _instance!;
  }

  LoggerTalkerImpl._internal();

  static LoggerTalkerImpl? _instance;

  static late final Talker _talker;

  @override
  void log(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _talker.debug(message, error, stackTrace);
  }

  @override
  void debug(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _talker.debug(message, error, stackTrace);
  }

  @override
  void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _talker.error(message, error, stackTrace);
  }

  @override
  void info(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _talker.info(message, error, stackTrace);
  }

  @override
  void warning(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _talker.warning(message, error, stackTrace);
  }
}
