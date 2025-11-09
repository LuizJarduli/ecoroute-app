// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResponseDTO _$AuthResponseDTOFromJson(Map<String, dynamic> json) =>
    AuthResponseDTO(
      accessToken: json['accessToken'] as String,
      expirationTime: (json['expirationTime'] as num).toInt(),
    );

Map<String, dynamic> _$AuthResponseDTOToJson(AuthResponseDTO instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'expirationTime': instance.expirationTime,
    };
