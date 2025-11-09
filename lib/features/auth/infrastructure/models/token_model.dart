import 'package:eco_route_mobile_app/features/auth/domain/entities/token.dart';

class TokenModel extends Token {
  const TokenModel({
    required super.accessToken,
    required super.expirationTime,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      accessToken: json['accessToken'] as String,
      expirationTime: DateTime.fromMillisecondsSinceEpoch((json['expirationTime'] as num).toInt())
    );
  }
}