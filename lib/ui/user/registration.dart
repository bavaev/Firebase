import 'package:firebase/business/bloc/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:firebase/business/bloc/bloc.dart';

class RegistrationPage extends StatelessWidget {
  RegistrationPage({Key? key}) : super(key: key);

  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // final blocContext = BlocProvider.of<ItemBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Регистрация'),
      ),
      body: Center(
        child: Column(
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
            const SizedBox(
              height: 50,
            ),
            Builder(
              builder: (context) => ElevatedButton(
                child: const Text('Зарегистрироваться'),
                onPressed: () {
                  context.read<ItemBloc>().add(RegistrationEvent(_email.text, _password.text));
                  Navigator.pushNamed(context, '/login');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
