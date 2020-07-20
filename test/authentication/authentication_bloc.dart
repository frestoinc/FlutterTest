import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterapp/data/entities/entities.dart';
import 'package:flutterapp/data/manager/data_manager.dart';
import 'package:flutterapp/ui/authentication/authentication.dart';
import 'package:mockito/mockito.dart';

class MockDataManager extends Mock implements DataManager {}

void main() {
  MockDataManager _manager;
  AuthenticationBloc _bloc;
  User _user;
  Either<Exception, String> _mockRightData;
  String _emailAddress;

  setUp(() {
    _manager = MockDataManager();
    _bloc = AuthenticationBloc(manager: _manager);
    _user = User(emailAddress: "abc@123.com", password: "12345");
    _mockRightData = Right(_user.emailAddress);
    _mockRightData.map((r) {
      _emailAddress = r;
    });
  });

  tearDown(() {
    _bloc.close();
  });

  test('Test for initial state', () {
    expect(_bloc.state, AuthenticationInitialState());
  });

  test('close does not emit new states', () {
    expectLater(
      _bloc,
      emitsInOrder([AuthenticationInitialState(), emitsDone]),
    );
    _bloc.close();
  });

  test('Test AuthenticationStartedEvent with no credentials', () async {
    when(_manager.validCredentials()).thenAnswer((_) async => false);
    expect(_manager.validCredentials(), completion(isFalse));

    expectLater(
        _bloc,
        emitsInOrder([
          AuthenticationInitialState(),
          AuthenticationInProgressState(),
          AuthenticationFailureState(),
        ]));

    _bloc.add(AuthenticationStartedEvent());
  });

  test('Test AuthenticationStartedEvent with valid credentials', () async {
    when(_manager.validCredentials()).thenAnswer((_) async => true);
    when(_manager.readCredentials()).thenAnswer((_) async => _mockRightData);

    expect(_manager.validCredentials(), completion(isTrue));
    expect(_manager.readCredentials(), completion(_mockRightData));

    expectLater(
        _bloc,
        emitsInOrder([
          AuthenticationInitialState(),
          AuthenticationInProgressState(),
          AuthenticationSuccessState(emailAddress: _emailAddress),
        ]));

    _bloc.add(AuthenticationStartedEvent());
  });

  test('Test AuthenticationLoggedInEvent with valid credentials', () {
    final futureUser = Future.value(_mockRightData);
    when(_manager.readCredentials()).thenAnswer((_) => futureUser);

    expectLater(
        _bloc,
        emitsInOrder([
          AuthenticationInitialState(),
          AuthenticationInProgressState(),
          AuthenticationSuccessState(emailAddress: _emailAddress),
        ]));

    _bloc.add(AuthenticationLoggedInEvent(user: _user));
  });

  test('Test AuthenticationLoggedOutEvent', () {
    final futureUser = Future.value(_mockRightData);
    when(_manager.readCredentials()).thenAnswer((_) => futureUser);

    expectLater(
        _bloc,
        emitsInOrder([
          AuthenticationInitialState(),
          AuthenticationInProgressState(),
          AuthenticationFailureState(),
        ]));

    _bloc.add(AuthenticationLoggedOutEvent());
  });

  test('Test for onLoggedOutPressed function', () {
    _bloc.onLoggedOutPressed();

    expectLater(
        _bloc,
        emitsInOrder([
          AuthenticationInitialState(),
          AuthenticationInProgressState(),
          AuthenticationFailureState(),
        ]));
  });
}
