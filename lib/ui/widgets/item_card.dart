import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:firebase/business/models/item.dart';
import 'package:firebase/business/bloc/item_bloc/item_bloc.dart';
import 'package:firebase/business/bloc/item_bloc/item_event.dart';
import 'package:firebase/business/bloc/item_bloc/item_state.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  const ItemCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.white, Colors.grey.shade300]),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            offset: Offset(5, 5),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(item.name),
          BlocBuilder<ItemBloc, ItemState>(builder: (context, state) {
            if (state is ItemLoadingState) {
              return const CircularProgressIndicator();
            } else if (state is ItemLoadedState) {
              return item.purchased
                  ? IconButton(
                      icon: const Icon(Icons.check_box),
                      onPressed: () => context.read<ItemBloc>().add(ChangeStateEvent(item.id, !item.purchased)),
                    )
                  : IconButton(
                      icon: const Icon(Icons.check_box_outline_blank_outlined),
                      onPressed: () => context.read<ItemBloc>().add(ChangeStateEvent(item.id, !item.purchased)),
                    );
            }
            return const Center(
              child: Text('Something went wrong!'),
            );
          }),
        ],
      ),
    );
  }
}
