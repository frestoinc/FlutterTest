import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterapp/data/entities/entities.dart';
import 'package:flutterapp/data/entities/model_entity.dart';
import 'package:flutterapp/extension/response.dart';
import 'package:flutterapp/ui/authentication/authentication_bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AuthenticationBloc authBloc;

  HomeBloc({@required this.authBloc})
      : assert(authBloc != null),
        super(HomeInitialState());

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
    await authBloc.manager.getRepositories().then((value) {
      value is SuccessState
          ? add(HomeSuccessEvent(list: value.value))
          : add(HomeErrorEvent(error: (value as ErrorState).exception));
    });
  }

  Stream<HomeState> _mapStateOfSortedEvent(
      int type, List<ModelEntity> list) async* {
    yield HomeLoadingState();
    if (list.length > 2) {
      switch (type) {
        case 1:
          list.sort((a, b) => b.stars.compareTo(a.stars));
          break;
        case 2:
          list.sort((a, b) => b.forks.compareTo(a.forks));
          break;
        case 3:
          list.shuffle();
          break;
        default:
          break;
      }
    }
    yield HomeSuccessState(entities: list);
  }

  Stream<HomeState> _mapStateOfErrorEvent(Exception e) async* {
    yield HomeFailureState(error: e);
  }

  Stream<HomeState> _mapStateOfSuccessEvent(List<ModelEntity> list) async* {
    yield HomeSuccessState(entities: list);
  }

  Future<void> fetchData() async {
    if (state is! HomeLoadingState) {
      add(HomeFetchedDataEvent());
    }
  }

  void handleOptionsMenu(int type) {
    if (type == 0) {
      authBloc.onLoggedOutPressed();
    } else {
      _sortList(type);
    }
  }

  void onReorder(int oldIndex, int newIndex) {
    if (state is HomeSuccessState) {
      var list = (state as HomeSuccessState).entities;
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      list.insert(newIndex, list.removeAt(oldIndex));
      add(HomeSortedEvent(type: 4, list: list));
    }
  }

  void _sortList(int type) async {
    await authBloc.manager.getRepositories().then((value) {
      value is SuccessState
          ? add(HomeSortedEvent(type: type, list: value.value))
          : add(HomeErrorEvent(error: (value as ErrorState).exception));
    });
  }

  void deleteItemList(ModelEntity entity) {
    if (state is HomeSuccessState) {
      var list = (state as HomeSuccessState).entities;
      list.remove(entity);
      add(HomeSortedEvent(type: 5, list: list));
    }
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

  @override
  List<Object> get props => [error];
}

class HomeSuccessEvent extends HomeEvent {
  final List<ModelEntity> list;

  const HomeSuccessEvent({@required this.list});

  @override
  List<Object> get props => [list];
}

class HomeSortedEvent extends HomeEvent {
  final int type;
  final List<ModelEntity> list;

  const HomeSortedEvent({@required this.type, @required this.list});

  @override
  List<Object> get props => [type, list];
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

  @override
  List<Object> get props => [entities];
}

class HomeFailureState extends HomeState {
  final Exception error;

  const HomeFailureState({@required this.error});

  @override
  List<Object> get props => [error];
}
