import 'package:equatable/equatable.dart';

abstract class ItemEvent extends Equatable {
  const ItemEvent();
}

class RegistrationEvent extends ItemEvent {
  const RegistrationEvent(this.email, this.password);

  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

class AuthenticateEvent extends ItemEvent {
  const AuthenticateEvent(this.login, this.email, this.password);

  final bool login;
  final String email;
  final String password;

  @override
  List<Object> get props => [login, email, password];
}

class AuthenticateGoogleEvent extends ItemEvent {
  const AuthenticateGoogleEvent(this.login);

  final bool login;

  @override
  List<Object> get props => [login];
}

class GetDataEvent extends ItemEvent {
  @override
  List<Object> get props => [];
}

class SortUpEvent extends ItemEvent {
  const SortUpEvent(this.sort);

  final bool sort;

  @override
  List<bool> get props => [sort];
}

class SortDownEvent extends ItemEvent {
  const SortDownEvent(this.sort);

  final bool sort;

  @override
  List<bool> get props => [sort];
}

class AddNewItemEvent extends ItemEvent {
  const AddNewItemEvent(this.value);

  final String value;

  @override
  List<String> get props => [value];
}

class ChangeStateEvent extends ItemEvent {
  const ChangeStateEvent(this.id, this.value);

  final String id;
  final bool value;

  @override
  List<dynamic> get props => [id, value];
}
