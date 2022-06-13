import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase/business/bloc/bloc.dart';
import 'package:firebase/business/bloc/event.dart';
import 'package:firebase/ui/list_items.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: ElevatedButton(
                onPressed: (() {
                  context.read<ItemBloc>().add(const AuthenticateEvent(false));
                }),
                child: const Text('Войти'),
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
