import 'package:firebase/data/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_state.dart';
import 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ItemRepository repository;

  @override
  AuthBloc(this.repository) : super(AuthentificateState()) {
    on<RegistrationEvent>(_registration);
    on<AuthenticateEvent>(_auth);
    on<AuthenticateGoogleEvent>(_authGoogle);
  }

  void _registration(event, emit) {
    repository.registration(event.email, event.password);
  }

  void _auth(event, emit) async {
    repository.auth(event.login, event.email, event.password);
  }

  void _authGoogle(event, emit) async {
    repository.googleAuth(event.login);
  }

  @override
  Future close() {
    repository.dispose();
    return super.close();
  }
}
