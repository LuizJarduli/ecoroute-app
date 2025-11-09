import 'package:equatable/equatable.dart';

class Token extends Equatable {
  const Token({
    required this.accessToken,
    required this.expirationTime,
  });

  final String accessToken;

  final DateTime expirationTime;
  
  @override
  List<Object?> get props => [accessToken, expirationTime];
}