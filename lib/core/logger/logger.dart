
abstract class Logger {
  void log(String message);
  void error(String message, [dynamic error, StackTrace? stackTrace]);
  void warning(String message);
  void info(String message);
  void debug(String message);
}
