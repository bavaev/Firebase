import 'package:firebase/data/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'state.dart';
import 'event.dart';
import 'package:firebase/business/models/item.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final ItemRepository repository;

  @override
  ItemBloc(this.repository) : super(ItemLoadingState()) {
    on<AuthenticateEvent>(_auth);
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

  void _auth(event, emit) async {
    repository.auth(event.login);
  }

  void _sortUp(event, emit) {
    repository.data(event.sort);
  }

  void _sortDown(event, emit) {
    repository.data(event.sort);
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
