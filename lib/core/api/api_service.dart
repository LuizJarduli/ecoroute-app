import 'dart:convert';

import 'package:eco_route_mobile_app/core/env/env.dart';
import 'package:eco_route_mobile_app/core/error/exceptions.dart';
import 'package:eco_route_mobile_app/core/logger/logger.dart';
import 'package:eco_route_mobile_app/features/auth/infrastructure/models/auth_response_dto.dart';
import 'package:eco_route_mobile_app/features/auth/infrastructure/models/user_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final Env _env;

  final Logger _logger;

  const ApiService(this._env, this._logger);

  Future<AuthResponseDTO> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${_env.baseUrl}/auth/login'),
        headers: {'Content-Type': 'application/json', 'Accept': '*/*'},
        body: jsonEncode({'username': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        return AuthResponseDTO.fromJson(json.decode(response.body));
      } else {
        throw ServerException();
      }
    } catch (error, stackTrace) {
      _logger.error('Error on login', error, stackTrace);
      throw ServerException();
    }
  }

  Future<UserModel> getAuthenticatedUser(String token) async {
    final response = await http.get(
      Uri.parse('${_env.baseUrl}/users/me'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  // SignUp method needs to be updated according to your API
  Future<UserModel> signUp(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('${_env.baseUrl}/signup'),
      body: {'name': name, 'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
