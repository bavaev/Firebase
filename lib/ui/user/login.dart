import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase/business/bloc/auth_bloc/auth_bloc.dart';
import 'package:firebase/business/bloc/auth_bloc/auth_event.dart';
import 'package:firebase/ui/list_items.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Войти'),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: _email,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextField(
                      controller: _password,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Пароль',
                      ),
                    ),
                    ElevatedButton(
                      child: const Text('Войти'),
                      onPressed: () {
                        context.read<AuthBloc>().add(AuthenticateEvent(false, _email.text, _password.text));
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    ElevatedButton(
                      child: const Text('Войти с Google'),
                      onPressed: () {
                        context.read<AuthBloc>().add(const AuthenticateGoogleEvent(false));
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text('Нет аккаунта?'),
                    ElevatedButton(
                      child: const Text('Зарегистрироваться'),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ListItems(title: 'Firebase'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const ListItems(title: 'Firebase');
        }
      },
    );
  }
}
