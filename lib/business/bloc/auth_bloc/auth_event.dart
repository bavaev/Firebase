import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class RegistrationEvent extends AuthEvent {
  const RegistrationEvent(this.email, this.password);

  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

class AuthenticateEvent extends AuthEvent {
  const AuthenticateEvent(this.login, this.email, this.password);

  final bool login;
  final String email;
  final String password;

  @override
  List<Object> get props => [login, email, password];
}

class AuthenticateGoogleEvent extends AuthEvent {
  const AuthenticateGoogleEvent(this.login);

  final bool login;

  @override
  List<Object> get props => [login];
}
