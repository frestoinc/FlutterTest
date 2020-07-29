import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterapp/data/entities/entities.dart';
import 'package:flutterapp/extension/response.dart';
import 'package:flutterapp/ui/authentication/authentication_bloc.dart';
import 'package:mockito/mockito.dart';

import 'mock_manager.dart';

void main() {
  MockDataManager _manager;
  AuthenticationBloc _bloc;

  setUp(() {
    _manager = MockDataManager();
    _bloc = AuthenticationBloc(manager: _manager);
  });

  tearDown(() {
    _bloc?.close();
  });

  test('Test for initial state', () async {
    expect(_bloc.state, AuthenticationInitialState());
  });

  test('throws when data manager is null', () {
    expect(
      () => AuthenticationBloc(manager: null),
      throwsAssertionError,
    );
  });

  group('Test AuthenticationStartedEvent', () {
    blocTest<AuthenticationBloc, AuthenticationState>(
        'Test with no credentials',
        build: () {
          when(_manager.validCredentials()).thenAnswer((_) async => false);
          return _bloc;
        },
        act: (bloc) => bloc.add(AuthenticationStartedEvent()),
        wait: const Duration(milliseconds: 6600),
        expect: [
          AuthenticationInProgressState(),
          AuthenticationFailureState(),
        ],
        verify: (_) async {
          verify(_manager.validCredentials()).called(1);
        });

    blocTest<AuthenticationBloc, AuthenticationState>(
        'Test with valid credentials',
        build: () {
          when(_manager.validCredentials()).thenAnswer((_) async => true);
          when(_manager.readCredentials()).thenAnswer(
              (_) async => SuccessState<String>('abc123@gmail.com'));
          return _bloc;
        },
        act: (bloc) => bloc.add(AuthenticationStartedEvent()),
        wait: const Duration(milliseconds: 6600),
        expect: [
          AuthenticationInProgressState(),
          AuthenticationSuccessState(emailAddress: 'abc123@gmail.com'),
        ],
        verify: (_) async {
          verify(_manager.validCredentials()).called(1);
          verify(_manager.readCredentials()).called(1);
        });
  });

  blocTest<AuthenticationBloc, AuthenticationState>(
      'Test AuthenticationLoggedInEvent with valid credentials',
      build: () => _bloc,
      act: (bloc) => bloc.add(AuthenticationLoggedInEvent(
          user: User(emailAddress: 'e', password: 'p'))),
      wait: const Duration(milliseconds: 600),
      expect: [
        AuthenticationInProgressState(),
        AuthenticationSuccessState(emailAddress: 'e')
      ],
      verify: (_) async {
        verify(_manager.saveCredentials(User(emailAddress: 'e', password: 'p')))
            .called(1);
      });

  group('Test AuthenticationLoggedOutEvent', () {
    blocTest<AuthenticationBloc, AuthenticationState>(
        'Test AuthenticationLoggedOutEvent',
        build: () => _bloc,
        act: (bloc) => bloc.add(AuthenticationLoggedOutEvent()),
        wait: const Duration(milliseconds: 600),
        expect: [AuthenticationInProgressState(), AuthenticationFailureState()],
        verify: (_) async {
          verify(_manager.deleteCredentials()).called(1);
        });

    blocTest<AuthenticationBloc, AuthenticationState>(
        'Test AuthenticationLoggedOutEvent',
        build: () {
          _bloc.onLoggedOutPressed();
          return _bloc;
        },
        wait: const Duration(milliseconds: 600),
        expect: [
          AuthenticationInProgressState(),
          AuthenticationFailureState(),
        ],
        verify: (_) async {
          verify(_manager.deleteCredentials()).called(1);
        });
  });
}
