import 'package:flutter_test/flutter_test.dart';
import 'package:flutterapp/ui/authentication/authentication_bloc.dart';
import 'package:flutterapp/ui/home/home_bloc.dart';

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

  //todo
}
