import 'package:json_annotation/json_annotation.dart';

part 'auth_response_dto.g.dart';

@JsonSerializable()
class AuthResponseDTO {
  final String accessToken;
  final int expirationTime;

  const AuthResponseDTO({
    required this.accessToken,
    required this.expirationTime,
  });

  factory AuthResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseDTOFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseDTOToJson(this);
}
