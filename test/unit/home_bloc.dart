import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterapp/data/entities/model_entity.dart';
import 'package:flutterapp/extension/response.dart';
import 'package:flutterapp/ui/authentication/authentication_bloc.dart';
import 'package:flutterapp/ui/home/home_bloc.dart';
import 'package:mockito/mockito.dart';

import 'data.dart';
import 'mock_manager.dart';

void main() {
  MockDataManager _manager;
  HomeBloc _homeBloc;
  AuthenticationBloc _authBloc;

  setUp(() {
    _manager = MockDataManager();
    _authBloc = AuthenticationBloc(manager: _manager);
    _homeBloc = HomeBloc(authBloc: _authBloc);
  });

  tearDown(() {
    _authBloc?.close();
    _homeBloc?.close();
  });

  test('Test for initial state', () {
    expect(_homeBloc.state, HomeInitialState());
  });

  test('throws when Authentication bloc is null', () {
    expect(
          () => HomeBloc(authBloc: null),
      throwsAssertionError,
    );
  });

  test('close does not emit new states', () {
    expectLater(
      _homeBloc,
      emitsInOrder([HomeInitialState(), emitsDone]),
    );
    _homeBloc.close();
  });

  group('Test HomeFetchedDataEvent', () {
    blocTest('Test with empty list',
        build: () async {
          when(_authBloc.manager.getRepositories()).thenAnswer(
              (_) async => SuccessState<List<ModelEntity>>(<ModelEntity>[]));
          return _homeBloc;
        },
        act: (bloc) => bloc.add(HomeFetchedDataEvent()),
        wait: const Duration(milliseconds: 1500),
        expect: [
          HomeLoadingState(),
          HomeSuccessState(entities: null),
        ],
        verify: (_) async {
          verify(_authBloc.manager.getRepositories()).called(1);
          expect(await _authBloc.manager.getRepositories(),
              isInstanceOf<SuccessState<List<ModelEntity>>>());
          var _response = await _authBloc.manager.getRepositories();
          List<ModelEntity> list = (_response as SuccessState).value;
          expect(list.length, 0);
        });

    blocTest('Test with error',
        build: () async {
          when(_manager.getRepositories()).thenAnswer((_) async =>
              ErrorState<Exception>(
                  TimeoutException(null, Duration(seconds: 10))));
          return _homeBloc;
        },
        act: (bloc) => bloc.add(HomeFetchedDataEvent()),
        wait: const Duration(milliseconds: 1500),
        expect: [
          HomeLoadingState(),
          HomeFailureState(error: null),
        ],
        verify: (_) async {
          verify(_authBloc.manager.getRepositories()).called(1);
          expect(await _authBloc.manager.getRepositories(),
              isInstanceOf<ErrorState<Exception>>());
          var _response = await _authBloc.manager.getRepositories();
          Exception _e = (_response as ErrorState).exception;
          expect(_e.toString(), contains('TimeoutException after'));
        });
  });

  blocTest(
    'Test HomeErrorEvent',
    build: () async => _homeBloc,
    act: (bloc) => bloc.add(HomeErrorEvent(error: null)),
    wait: const Duration(milliseconds: 600),
    expect: [HomeFailureState(error: null)],
  );

  blocTest(
    'Test HomeSuccessEvent',
    build: () async => _homeBloc,
    act: (bloc) => bloc.add(HomeSuccessEvent(list: null)),
    wait: const Duration(milliseconds: 600),
    expect: [HomeSuccessState(entities: null)],
  );

  group('Test HomeSortedEvent', () {
    blocTest(
      'Test with type 1, empty list',
      build: () async {
        return _homeBloc;
      },
      act: (bloc) => bloc.add(HomeSortedEvent(type: 1, list: <ModelEntity>[])),
      wait: const Duration(milliseconds: 600),
      expect: [HomeLoadingState(), HomeSuccessState(entities: null)],
    );

    for (var i = 1; i < 3; i++) {
      blocTest('Test with type',
          build: () async {
            return _homeBloc;
          },
          act: (bloc) => bloc.add(HomeSortedEvent(type: i, list: list)),
          wait: const Duration(milliseconds: 600),
          expect: [HomeLoadingState(), HomeSuccessState(entities: null)],
          verify: (_) async {
            expect(list.length, 3);
            switch (i) {
              case 1:
                assert(list.first.stars > list.last.stars);
                break;
              case 2:
                assert(list.first.forks > list.last.forks);
                break;
              default:
                break;
            }
          });
    }
  });
}
