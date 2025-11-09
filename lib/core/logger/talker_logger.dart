
import 'package:talker_flutter/talker_flutter.dart';
import 'logger.dart';

class TalkerLogger implements Logger {
  final Talker talker;

  TalkerLogger(this.talker);

  @override
  void log(String message) {
    talker.log(message);
  }

  @override
  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    talker.error(message, error, stackTrace);
  }

  @override
  void warning(String message) {
    talker.warning(message);
  }

  @override
  void info(String message) {
    talker.info(message);
  }

  @override
  void debug(String message) {
    talker.debug(message);
  }
}
