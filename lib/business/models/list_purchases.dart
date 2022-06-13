import 'package:equatable/equatable.dart';

import 'item.dart';

class ListPurchases extends Equatable {
  const ListPurchases({this.items = const <Item>[]});

  final List<Item> items;

  @override
  List<Object> get props => [items];
}
