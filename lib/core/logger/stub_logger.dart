
import 'logger.dart';

class StubLogger implements Logger {
  const StubLogger();

  @override
  void log(String message) {}

  @override
  void error(String message, [dynamic error, StackTrace? stackTrace]) {}

  @override
  void warning(String message) {}

  @override
  void info(String message) {}

  @override
  void debug(String message) {}
}
