import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

class LoggedIn extends AuthEvent {
  final String email;
  final String password;

  const LoggedIn({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class SignedUp extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const SignedUp(
      {required this.name, required this.email, required this.password});

  @override
  List<Object> get props => [name, email, password];
}

class LoggedOut extends AuthEvent {}
