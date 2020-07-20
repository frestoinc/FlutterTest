import 'package:flutter_test/flutter_test.dart';
import 'package:flutterapp/extension/extension.dart';
import 'package:flutterapp/ui/authentication/authentication.dart';
import 'package:flutterapp/ui/login/login_bloc.dart';

import '../mock_manager.dart';

void main() {
  MockDataManager _manager;
  LoginBloc _loginBloc;

  setUp(() {
    _manager = MockDataManager();
    AuthenticationBloc _authBloc = AuthenticationBloc(manager: _manager);
    _loginBloc = LoginBloc(authBloc: _authBloc);
    _authBloc.close();
  });

  tearDown(() {
    _loginBloc.close();
  });

  test('Test for initial state', () {
    expect(_loginBloc.state, LoginInitialState());
  });

  test('close does not emit new states', () {
    expectLater(
      _loginBloc,
      emitsInOrder([LoginInitialState(), emitsDone]),
    );
    _loginBloc.close();
  });

  group('Test LoginEmailChangedEvent', () {
    test('Test LoginEmailChangedEvent with valid email format', () async {
      _loginBloc.emailController.text = "abc@gmail.com";

      expectLater(
          _loginBloc,
          emitsInOrder([
            LoginInitialState(),
            LoginEditingState(),
          ]));

      _loginBloc.add(LoginEmailChangedEvent());
    });

    test('Test onLoginEmailChanged function with valid email format', () async {
      _loginBloc.emailController.text = "abc@gmail.com";
      _loginBloc.onLoginEmailChanged();

      expectLater(
          _loginBloc,
          emitsInOrder([
            LoginInitialState(),
            LoginEditingState(),
          ]));

      _loginBloc.add(LoginEmailChangedEvent());
    });

    test('Test LoginEmailChangedEvent with invalid email format', () async {
      _loginBloc.emailController.text = "asfagds";

      expectLater(
          _loginBloc,
          emitsInOrder([
            LoginInitialState(),
            LoginFailureState(error: null),
          ]));

      _loginBloc.add(LoginEmailChangedEvent());
    });

    test('Test onLoginEmailChanged with function with invalid email format',
        () async {
      _loginBloc.emailController.text = "asfagds";
      _loginBloc.onLoginEmailChanged();
      expectLater(
          _loginBloc,
          emitsInOrder([
            LoginInitialState(),
            LoginFailureState(error: null),
          ]));

      _loginBloc.add(LoginEmailChangedEvent());
    });
  });

  group('Test LoginPasswordChangedEvent', () {
    test('Test LoginPasswordChangedEvent with valid pwd format', () async {
      _loginBloc.passwordController.text = "1234567";

      expectLater(
          _loginBloc,
          emitsInOrder([
            LoginInitialState(),
            LoginEditingState(),
          ]));

      _loginBloc.add(LoginPasswordChangedEvent());
    });

    test('Test onLoginPasswordChanged function with valid pwd format',
        () async {
      _loginBloc.passwordController.text = "1234567";
      _loginBloc.onLoginPasswordChanged();

      expectLater(
          _loginBloc,
          emitsInOrder([
            LoginInitialState(),
            LoginEditingState(),
          ]));

      _loginBloc.add(LoginPasswordChangedEvent());
    });

    test('Test LoginPasswordChangedEvent with invalid pwd format', () async {
      _loginBloc.passwordController.text = "123";

      expectLater(
          _loginBloc,
          emitsInOrder([
            LoginInitialState(),
            LoginFailureState(error: null),
          ]));

      _loginBloc.add(LoginPasswordChangedEvent());
    });

    test('Test onLoginPasswordChanged with function with invalid pwd format',
        () async {
      _loginBloc.passwordController.text = "123";
      _loginBloc.onLoginPasswordChanged();
      expectLater(
          _loginBloc,
          emitsInOrder([
            LoginInitialState(),
            LoginFailureState(error: null),
          ]));

      _loginBloc.add(LoginPasswordChangedEvent());
    });
  });

  group('Test LoginButtonPressedEvent', () {
    test('Test LoginPasswordChangedEvent with valid credentials', () async {
      _loginBloc.emailController.text = LOGIN_EMAIL_HINT;
      _loginBloc.passwordController.text = LOGIN_PASSWORD_HINT;

      expectLater(
          _loginBloc,
          emitsInOrder([
            LoginInitialState(),
            LoginLoadingState(),
            AuthenticationLoggedInEvent(user: null),
          ]));

      _loginBloc.add(LoginButtonPressedEvent());
    });

    test('Test onFormSubmitted function with valid credentials', () async {
      _loginBloc.emailController.text = LOGIN_EMAIL_HINT;
      _loginBloc.passwordController.text = LOGIN_PASSWORD_HINT;
      _loginBloc.onFormSubmitted();

      expectLater(
          _loginBloc,
          emitsInOrder([
            LoginInitialState(),
            LoginLoadingState(),
            AuthenticationLoggedInEvent(user: null),
          ]));

      _loginBloc.add(LoginButtonPressedEvent());
    });

    test('Test LoginPasswordChangedEvent with invalid credentials', () async {
      _loginBloc.emailController.text = "abc@gmail.com";
      _loginBloc.passwordController.text = "123";

      expectLater(
          _loginBloc,
          emitsInOrder([
            LoginInitialState(),
            LoginLoadingState(),
            LoginFailureState(error: null),
            LoginFormFailureState(error: null),
          ]));

      _loginBloc.add(LoginButtonPressedEvent());
    });

    test('Test onLoginPasswordChanged with function with invalid credentials',
        () async {
      _loginBloc.emailController.text = "abc@gmail.com";
      _loginBloc.passwordController.text = "123";
      _loginBloc.onFormSubmitted();

      expectLater(
          _loginBloc,
          emitsInOrder([
            LoginInitialState(),
            LoginLoadingState(),
            LoginFailureState(error: null),
            LoginFormFailureState(error: null),
          ]));

      _loginBloc.add(LoginButtonPressedEvent());
    });
  });
}
