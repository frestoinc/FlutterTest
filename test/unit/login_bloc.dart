import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterapp/extension/extension.dart';
import 'package:flutterapp/ui/authentication/authentication_bloc.dart';
import 'package:flutterapp/ui/login/login_bloc.dart';

import 'mock_manager.dart';

void main() {
  MockDataManager _manager;
  LoginBloc _loginBloc;
  AuthenticationBloc _authBloc;

  setUp(() {
    _manager = MockDataManager();
    _authBloc = AuthenticationBloc(manager: _manager);
    _loginBloc = LoginBloc(authBloc: _authBloc);
  });

  tearDown(() {
    _authBloc?.close();
    _loginBloc?.close();
  });

  test('Test for initial state', () {
    expect(_loginBloc.state, LoginInitialState());
  });

  test('throws when Authentication bloc is null', () {
    expect(
      () => LoginBloc(authBloc: null),
      throwsAssertionError,
    );
  });

  test('close does not emit new states', () {
    expectLater(
      _loginBloc,
      emitsInOrder([LoginInitialState(), emitsDone]),
    );
    _loginBloc.close();
  });

  group('Test LoginEmailChangedEvent', () {
    blocTest(
      'Test with valid email format',
      build: () async {
        _loginBloc.emailController.text = 'abc@gmail.com';
        return _loginBloc;
      },
      act: (bloc) => bloc.add(LoginEmailChangedEvent()),
      wait: const Duration(milliseconds: 500),
      expect: [LoginEditingState()],
    );

    blocTest(
      'Test onLoginEmailChanged function with valid email format',
      build: () async {
        _loginBloc.emailController.text = 'abc@gmail.com';
        _loginBloc.onLoginEmailChanged();
        return _loginBloc;
      },
      wait: const Duration(milliseconds: 500),
      expect: [LoginEditingState()],
    );

    blocTest(
      'Test with invalid email format',
      build: () async {
        _loginBloc.emailController.text = 'qwqrfase';
        return _loginBloc;
      },
      act: (bloc) => bloc.add(LoginEmailChangedEvent()),
      wait: const Duration(milliseconds: 500),
      expect: [LoginFailureState(error: null)],
    );

    blocTest(
      'Test onLoginEmailChanged function with invalid email format',
      build: () async {
        _loginBloc.emailController.text = 'qwrtasd';
        _loginBloc.onLoginEmailChanged();
        return _loginBloc;
      },
      wait: const Duration(milliseconds: 500),
      expect: [LoginFailureState(error: null)],
    );
  });

  group('Test LoginPasswordChangedEvent', () {
    blocTest(
      'Test with valid pwd format',
      build: () async {
        _loginBloc.passwordController.text = '1234567';
        return _loginBloc;
      },
      act: (bloc) => bloc.add(LoginPasswordChangedEvent()),
      wait: const Duration(milliseconds: 500),
      expect: [LoginEditingState()],
    );

    blocTest(
      'Test onLoginPasswordChanged function with valid pwd format',
      build: () async {
        _loginBloc.passwordController.text = '1234567';
        _loginBloc.onLoginPasswordChanged();
        return _loginBloc;
      },
      wait: const Duration(milliseconds: 500),
      expect: [LoginEditingState()],
    );

    blocTest(
      'Test with invalid pwd format',
      build: () async {
        _loginBloc.passwordController.text = 'abc';
        return _loginBloc;
      },
      act: (bloc) => bloc.add(LoginPasswordChangedEvent()),
      wait: const Duration(milliseconds: 500),
      expect: [LoginFailureState(error: null)],
    );

    blocTest(
      'Test onLoginPasswordChanged function with invalid pwd format',
      build: () async {
        _loginBloc.passwordController.text = 'abc';
        _loginBloc.onLoginPasswordChanged();
        return _loginBloc;
      },
      wait: const Duration(milliseconds: 500),
      expect: [LoginFailureState(error: null)],
    );
  });

  //todo review
  group('Test LoginButtonPressedEvent', () {
    blocTest(
      'Test onFormSubmitted function with valid credentials',
      build: () async {
        _loginBloc.emailController.text = LOGIN_EMAIL_HINT;
        _loginBloc.passwordController.text = LOGIN_PASSWORD_HINT;
        _loginBloc.onFormSubmitted();
        return _loginBloc;
      },
      wait: const Duration(milliseconds: 3500),
      expect: [
        LoginLoadingState(),
      ],
    );

    blocTest(
      'Test LoginButtonPressedEvent with valid credentials',
      build: () async {
        _loginBloc.emailController.text = LOGIN_EMAIL_HINT;
        _loginBloc.passwordController.text = LOGIN_PASSWORD_HINT;
        return _loginBloc;
      },
      act: (bloc) => bloc.add(LoginButtonPressedEvent()),
      wait: const Duration(milliseconds: 3500),
      expect: [
        LoginLoadingState(),
      ],
    );

    blocTest(
      'Test onFormSubmitted function with invalid credentials',
      build: () async {
        _loginBloc.emailController.text = 'abc@123.com';
        _loginBloc.passwordController.text = 'qwer54321';
        _loginBloc.onFormSubmitted();
        return _loginBloc;
      },
      wait: const Duration(milliseconds: 3500),
      expect: [
        LoginLoadingState(),
        LoginFailureState(error: null),
        LoginFormFailureState(error: null),
      ],
    );

    blocTest(
      'Test LoginButtonPressedEvent with invalid credentials',
      build: () async {
        _loginBloc.emailController.text = 'abc@123.com';
        _loginBloc.passwordController.text = 'qwer54321';
        return _loginBloc;
      },
      act: (bloc) => bloc.add(LoginButtonPressedEvent()),
      wait: const Duration(milliseconds: 3500),
      expect: [
        LoginLoadingState(),
        LoginFailureState(error: null),
        LoginFormFailureState(error: null),
      ],
    );
  });
}
