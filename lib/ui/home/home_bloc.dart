import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterapp/data/entities/model_entity.dart';
import 'package:flutterapp/data/manager/data_manager.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final DataManager manager;

  /* @override
  get initialState => HomeInitialState();*/

  HomeBloc({@required this.manager}) : super(HomeInitialState());

  @override
  Stream<Transition<HomeEvent, HomeState>> transformEvents(
    Stream<HomeEvent> events,
    TransitionFunction<HomeEvent, HomeState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is HomeFetchedDataEvent) {
      yield* _mapStateOfFetchedData();
    } else if (event is HomeErrorEvent) {
      yield* _mapStateOfErrorEvent(event.error);
    } else if (event is HomeSuccessEvent) {
      yield* _mapStateOfSuccessEvent(event.list);
    }
  }

  Stream<HomeState> _mapStateOfFetchedData() async* {
    print("_mapStateOfFetchedData");
    yield HomeLoadingState();
    print("current state: $state");
    await manager.getRepositories().then((value) => {
          if (value.isLeft())
            {
              value.leftMap((l) {
                this.add(HomeErrorEvent(error: l));
                print("exception occurred: $l");
              })
            }
          else
            {
              value.map((r) {
                this.add(HomeSuccessEvent(list: r));
                print("all ok: ${r.length}");
              })
            }
        });

    print("end");
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
}
