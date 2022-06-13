import 'package:firebase/business/bloc/event.dart';
import 'package:firebase/business/bloc/state.dart';
import 'package:firebase/ui/list_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:firebase/business/bloc/bloc.dart';
import 'package:firebase/data/repository.dart';

import 'package:firebase/login.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/login': (context) => const Login(),
        '/list': (context) => const ListItems(title: 'Firebase'),
      },
      home: RepositoryProvider<ItemRepository>(
        create: (context) => ItemRepositoryFirestore()..data(false),
        child: BlocProvider<ItemBloc>(
          create: (context) => ItemBloc(RepositoryProvider.of(context))..add(GetDataEvent()),
          child: const Login(),
        ),
      ),
    );
  }
}
