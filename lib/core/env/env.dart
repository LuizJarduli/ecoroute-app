sealed class _EnvKeys {
  static const BASE_URL = 'BASE_URL';
}

/// This class is used to get the environment variables from the command line
/// when running the app.
///
/// The class is a singleton, so it can be used anywhere in the app.
///
/// ! Every new environment variable should be added to the _EnvKeys class. Then
/// ! it should be added to the _env map in the Env class. Finally, it should be
/// ! added to the getter method in the Env class.
final class Env {
  final Map<String, dynamic> _env = {
    _EnvKeys.BASE_URL: const String.fromEnvironment(
      _EnvKeys.BASE_URL,
    ),
  };

  static Env? _instance;

  Env._internal();

  factory Env.getInstance() {
    return _instance ??= Env._internal();
  }

  String get baseUrl => _env[_EnvKeys.BASE_URL] as String;
}
