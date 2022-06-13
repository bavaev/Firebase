import 'package:equatable/equatable.dart';

import 'package:firebase/business/models/item.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class ItemState extends Equatable {
  const ItemState();
}

class ItemLoadingState extends ItemState {
  @override
  List<Item> get props => [];
}

class ItemLoadedState extends ItemState {
  const ItemLoadedState(this.data);

  final List<Item> data;

  @override
  List<Object> get props => [data];
}

class ItemError extends ItemState {
  @override
  List<Object> get props => [];
}
