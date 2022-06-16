import 'package:firebase/business/models/item.dart';
import 'package:flutter/material.dart';

import 'package:firebase/ui/widgets/item_card.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:firebase/business/bloc/item_bloc/item_bloc.dart';
import 'package:firebase/business/bloc/item_bloc/item_event.dart';
import 'package:firebase/business/bloc/item_bloc/item_state.dart';
import 'package:firebase/business/bloc/auth_bloc/auth_bloc.dart';
import 'package:firebase/business/bloc/auth_bloc/auth_event.dart';

class ListItems extends StatefulWidget {
  const ListItems({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<ListItems> createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  final _text = TextEditingController();
  bool? order;
  late Future imageUrl;

  @override
  void initState() {
    super.initState();
    imageUrl = getImage();
  }

  Future getImage() async {
    return await FirebaseStorage.instance.refFromURL('gs://fir-23c0b.appspot.com/priroda-zima-derevo-sneg-solntse.jpg').getDownloadURL();
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
    final blocContext = BlocProvider.of<ItemBloc>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title),
            IconButton(
              onPressed: (() {
                context.read<AuthBloc>().add(const AuthenticateEvent(true, '', ''));
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
                      }),
                      icon: const Icon(Icons.keyboard_arrow_up),
                      iconSize: 50,
                    ),
                    IconButton(
                      onPressed: (() {
                        blocContext.add(const SortDownEvent(true));
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
                              setState(() {
                                order = false;
                              });
                            },
                            icon: const Icon(Icons.check_box_outline_blank),
                            iconSize: 40,
                          )
                        : IconButton(
                            onPressed: () {
                              setState(() {
                                order = true;
                              });
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
              future: imageUrl,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(snapshot.data),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: BlocBuilder<ItemBloc, ItemState>(
                        builder: (context, state) {
                          return state is ItemLoadedState
                              ? ListView(
                                  children: filter(state.data).map((item) => ItemCard(item: item)).toList(),
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                );
                        },
                      ));
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
              return Container(
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
