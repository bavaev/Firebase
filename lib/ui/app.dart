import 'package:firebase/ui/list_items.dart';
import 'package:firebase/ui/user/registration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:firebase/business/bloc/item_bloc/item_bloc.dart';
import 'package:firebase/business/bloc/item_bloc/item_event.dart';
import 'package:firebase/business/bloc/auth_bloc/auth_bloc.dart';
import 'package:firebase/data/repository.dart';

import 'package:firebase/ui/user/login.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<ItemRepository>(
      create: (context) => ItemRepositoryFirestore()..data(false),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ItemBloc(RepositoryProvider.of(context))..add(GetDataEvent()),
          ),
          BlocProvider(
            create: (context) => AuthBloc(RepositoryProvider.of(context)),
          ),
        ],
        child: MaterialApp(
          title: 'Firebase',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          routes: {
            '/login': (context) => Login(),
            '/registration': (context) => RegistrationPage(),
            '/list': (context) => const ListItems(title: 'Firebase'),
          },
          home: Login(),
        ),
      ),
    );
  }
}
