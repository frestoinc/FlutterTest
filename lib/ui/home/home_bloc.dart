import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterapp/data/entities/entities.dart';
import 'package:flutterapp/data/entities/model_entity.dart';
import 'package:flutterapp/data/manager/data_manager.dart';
import 'package:flutterapp/ui/authentication/authentication.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final DataManager manager;
  final AuthenticationBloc authBloc;

  HomeBloc({@required this.manager, @required this.authBloc})
      : super(HomeInitialState());

  @override
  Stream<Transition<HomeEvent, HomeState>> transformEvents(
    Stream<HomeEvent> events,
    Stream<Transition<HomeEvent, HomeState>> Function(
      HomeEvent event,
    )
        transitionFn,
  ) {
    return events
        .debounceTime(const Duration(milliseconds: 500))
        .switchMap(transitionFn);
  }

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is HomeFetchedDataEvent) {
      yield* _mapStateOfFetchedData();
    }

    if (event is HomeErrorEvent) {
      yield* _mapStateOfErrorEvent(event.error);
    }

    if (event is HomeSuccessEvent) {
      yield* _mapStateOfSuccessEvent(event.list);
    }

    if (event is HomeSortedEvent) {
      yield* _mapStateOfSortedEvent(event.type, event.list);
    }
  }

  Stream<HomeState> _mapStateOfFetchedData() async* {
    yield HomeLoadingState();
    await manager.getRepositories().then(
        (value) => value.fold((l) => this.add(HomeErrorEvent(error: l)), (r) {
              r.shuffle();
              this.add(HomeSuccessEvent(list: r));
            }));
  }

  Stream<HomeState> _mapStateOfSortedEvent(
      int type, List<ModelEntity> list) async* {
    yield HomeLoadingState();
    List<ModelEntity> clone = list;
    switch (type) {
      case 1:
        clone.sort((a, b) => b.stars.compareTo(a.stars));
        break;
      case 2:
        clone.sort((a, b) => b.forks.compareTo(a.forks));
        break;
      case 3:
        clone.shuffle();
        break;
      default:
        break;
    }
    this.add(HomeSuccessEvent(list: clone));
  }

  Stream<HomeState> _mapStateOfErrorEvent(Exception e) async* {
    yield HomeFailureState(error: e);
  }

  Stream<HomeState> _mapStateOfSuccessEvent(List<ModelEntity> list) async* {
    yield HomeSuccessState(entities: list);
  }

  Future<Null> fetchData() async {
    if (state is! HomeLoadingState) {
      this.add(HomeFetchedDataEvent());
    }
  }

  void handleOptionsMenu(int type) {
    if (type == 0) {
      authBloc.onLoggedOutPressed();
    } else {
      _sortList(type);
    }
  }

  void onReorder(List<ModelEntity> list, int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final ModelEntity entity = list.removeAt(oldIndex);
    list.insert(newIndex, entity);
    this.add(HomeSortedEvent(type: 4, list: list));
  }

  void _sortList(int type) async {
    await manager.getRepositories().then((value) => value.fold(
        (l) => this.add(HomeErrorEvent(error: l)),
        (r) => this.add(HomeSortedEvent(type: type, list: r))));
  }
}

@immutable
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeFetchedDataEvent extends HomeEvent {}

class HomeErrorEvent extends HomeEvent {
  final Exception error;

  const HomeErrorEvent({@required this.error});
}

class HomeSuccessEvent extends HomeEvent {
  final List<ModelEntity> list;

  const HomeSuccessEvent({@required this.list});
}

class HomeSortedEvent extends HomeEvent {
  final int type;
  final List<ModelEntity> list;

  const HomeSortedEvent({@required this.type, @required this.list});
}

@immutable
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitialState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeSuccessState extends HomeState {
  final List<ModelEntity> entities;

  const HomeSuccessState({@required this.entities});
}

class HomeFailureState extends HomeState {
  final Exception error;

  const HomeFailureState({@required this.error});
}
