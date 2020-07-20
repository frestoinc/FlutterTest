import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterapp/data/entities/entities.dart';
import 'package:flutterapp/ui/authentication/authentication.dart';
import 'package:mockito/mockito.dart';

import '../mock_manager.dart';

const User _mockUser = User(emailAddress: "abc@123.com", password: "12345");
const Either<Exception, String> _mockUserRightData = Right("abc@123.com");

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

  test('close does not emit new states', () async {
    expectLater(
      _bloc,
      emitsInOrder([AuthenticationInitialState(), emitsDone]),
    );
    _bloc.close();
  });

  group('Test AuthenticationStartedEvent', () {
    blocTest('Test with no credentials',
        build: () async {
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
    blocTest('Test with valid credentials',
        build: () async {
          when(_manager.validCredentials()).thenAnswer((_) async => true);
          when(_manager.readCredentials())
              .thenAnswer((_) async => _mockUserRightData);
          return _bloc;
        },
        act: (bloc) => bloc.add(AuthenticationStartedEvent()),
        wait: const Duration(milliseconds: 6600),
        expect: [
          AuthenticationInProgressState(),
          AuthenticationSuccessState(emailAddress: null),
        ],
        verify: (_) async {
          verify(_manager.validCredentials()).called(1);
          verify(_manager.readCredentials()).called(1);
        });
  });

  blocTest('Test AuthenticationLoggedInEvent with valid credentials',
      build: () async => _bloc,
      act: (bloc) => bloc.add(AuthenticationLoggedInEvent(user: _mockUser)),
      wait: const Duration(milliseconds: 600),
      expect: [
        AuthenticationInProgressState(),
        AuthenticationSuccessState(emailAddress: null)
      ],
      verify: (_) async {
        verify(_manager.saveCredentials(_mockUser)).called(1);
      });

  group('Test AuthenticationLoggedOutEvent', () {
    blocTest('Test AuthenticationLoggedOutEvent',
        build: () async => _bloc,
        act: (bloc) => bloc.add(AuthenticationLoggedOutEvent()),
        wait: const Duration(milliseconds: 600),
        expect: [AuthenticationInProgressState(), AuthenticationFailureState()],
        verify: (_) async {
          verify(_manager.deleteCredentials()).called(1);
        });

    blocTest('Test AuthenticationLoggedOutEvent',
        build: () async {
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
