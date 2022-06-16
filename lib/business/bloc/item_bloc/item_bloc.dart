import 'package:flutter_bloc/flutter_bloc.dart';

import 'item_state.dart';
import 'item_event.dart';
import 'package:firebase/business/models/item.dart';
import 'package:firebase/data/repository.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final ItemRepository repository;

  @override
  ItemBloc(this.repository) : super(ItemLoadingState()) {
    on<GetDataEvent>((event, emit) async {
      await emit.forEach(
        repository.purchases(),
        onData: (List<Item> data) {
          return ItemLoadedState(data);
        },
      );
    });
    on<SortUpEvent>(_sortUp);
    on<SortDownEvent>(_sortDown);
    on<AddNewItemEvent>(_addDoc);
    on<ChangeStateEvent>(_changeState);
  }

  void _sortUp(event, emit) {
    repository.data(event.sort);
    emit(ItemLoadingState());
  }

  void _sortDown(event, emit) {
    repository.data(event.sort);
    emit(ItemLoadingState());
  }

  void _addDoc(event, emit) async {
    if (state is ItemLoadedState) {
      repository.add(event.value);
      emit(ItemLoadingState());
    }
  }

  void _changeState(event, emit) async {
    if (state is ItemLoadedState) {
      repository.update(event.id, event.value);
      emit(ItemLoadingState());
    }
  }

  @override
  Future close() {
    repository.dispose();
    return super.close();
  }
}
