import 'package:firebase/business/bloc/event.dart';
import 'package:firebase/business/bloc/state.dart';
import 'package:flutter/material.dart';

import 'package:firebase/ui/widgets/item_card.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:firebase/business/bloc/bloc.dart';

class ListItems extends StatefulWidget {
  const ListItems({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<ListItems> createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  final _text = TextEditingController();
  bool? order;

  Future<String> getImage() async {
    final imageUrl = await FirebaseStorage.instance.refFromURL('gs://fir-23c0b.appspot.com/priroda-zima-derevo-sneg-solntse.jpg').getDownloadURL();
    return imageUrl;
  }

  List<dynamic> filter(List<dynamic> data) {
    List<dynamic> list = [];
    if (order == true) {
      for (var item in data) {
        if (item.purchased) {
          list.add(item);
        }
      }
      return list;
    } else if (order == false) {
      for (var item in data) {
        if (!item.purchased) {
          list.add(item);
        }
      }
      return list;
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ItemBloc>().state;
    final blocContext = BlocProvider.of<ItemBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title),
            IconButton(
              onPressed: (() {
                context.read<ItemBloc>().add(const AuthenticateEvent(true, '', ''));
              }),
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: (() {
                        blocContext.add(const SortUpEvent(false));
                        setState(() {});
                      }),
                      icon: const Icon(Icons.keyboard_arrow_up),
                      iconSize: 50,
                    ),
                    IconButton(
                      onPressed: (() {
                        blocContext.add(const SortDownEvent(true));
                        setState(() {});
                      }),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      iconSize: 50,
                    ),
                  ],
                ),
                Row(
                  children: [
                    order ?? true
                        ? IconButton(
                            onPressed: () {
                              order = false;
                              setState(() {});
                            },
                            icon: const Icon(Icons.check_box_outline_blank),
                            iconSize: 40,
                          )
                        : IconButton(
                            onPressed: () {
                              order = true;
                              setState(() {});
                            },
                            icon: const Icon(Icons.check_box),
                            iconSize: 40,
                          ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: getImage(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(snapshot.data),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: state is ItemLoadedState
                        ? ListView(
                            children: filter(state.data).map((e) => ItemCard(item: e)).toList(),
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return SizedBox(
                height: 150,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _text,
                        ),
                      ),
                      ElevatedButton(
                        child: const Text('Добавить'),
                        onPressed: () {
                          blocContext.add(AddNewItemEvent(_text.text));
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
