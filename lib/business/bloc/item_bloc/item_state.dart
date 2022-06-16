import 'package:equatable/equatable.dart';

import 'package:firebase/business/models/item.dart';

abstract class ItemState extends Equatable {
  const ItemState();
}

class ItemLoadingState extends ItemState {
  @override
  List<Item> get props => [];
}

class ItemLoadedState extends ItemState {
  final List<Item> data;

  const ItemLoadedState(this.data);

  @override
  List<Object> get props => [data];
}

class ItemError extends ItemState {
  @override
  List<Object> get props => [];
}
