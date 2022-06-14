import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase/business/bloc/bloc.dart';
import 'package:firebase/business/bloc/event.dart';
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
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _email,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
                const SizedBox(
                  height: 50,
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
                    context.read<ItemBloc>().add(AuthenticateEvent(false, _email.text, _password.text));
                  },
                ),
                ElevatedButton(
                  child: const Text('Войти с Google'),
                  onPressed: () {
                    context.read<ItemBloc>().add(const AuthenticateGoogleEvent(false));
                  },
                ),
                const SizedBox(
                  height: 100,
                ),
                const Text('Нет аккаунта?'),
                ElevatedButton(
                  child: const Text('Зарегистрироваться'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/registration');
                  },
                ),
              ],
            ),
          );
        } else {
          return const ListItems(title: 'Firebase');
        }
      },
    );
  }
}
