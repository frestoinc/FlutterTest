import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterapp/data/entities/entities.dart';
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

  group('Test LoginEmailChangedEvent', () {
    blocTest<LoginBloc, LoginState>(
      'Test with valid email format',
      build: () {
        return _loginBloc;
      },
      act: (bloc) => bloc.add(LoginEmailChangedEvent(value: 'abc@gmail.com')),
      wait: const Duration(milliseconds: 500),
      expect: [LoginEditingState()],
    );

    blocTest<LoginBloc, LoginState>(
      'Test onLoginEmailChanged function with valid email format',
      build: () {
        _loginBloc.onLoginEmailChanged('abc@gmail.com');
        return _loginBloc;
      },
      wait: const Duration(milliseconds: 500),
      expect: [LoginEditingState()],
    );

    blocTest<LoginBloc, LoginState>(
      'Test with invalid email format',
      build: () {
        return _loginBloc;
      },
      act: (bloc) => bloc.add(LoginEmailChangedEvent(value: 'qwrtasd')),
      wait: const Duration(milliseconds: 500),
      expect: [
        LoginFailureState(error: [EMAIL_ERROR, null])
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'Test onLoginEmailChanged function with invalid email format',
      build: () {
        _loginBloc.onLoginEmailChanged('qwrtasd');
        return _loginBloc;
      },
      wait: const Duration(milliseconds: 500),
      expect: [
        LoginFailureState(error: [EMAIL_ERROR, null])
      ],
    );
  });

  group('Test LoginPasswordChangedEvent', () {
    blocTest<LoginBloc, LoginState>(
      'Test with valid pwd format',
      build: () {
        return _loginBloc;
      },
      act: (bloc) => bloc.add(LoginPasswordChangedEvent(value: '1234567')),
      wait: const Duration(milliseconds: 500),
      expect: [LoginEditingState()],
    );

    blocTest<LoginBloc, LoginState>(
      'Test onLoginPasswordChanged function with valid pwd format',
      build: () {
        _loginBloc.onLoginPasswordChanged('1234567');
        return _loginBloc;
      },
      wait: const Duration(milliseconds: 500),
      expect: [LoginEditingState()],
    );

    blocTest<LoginBloc, LoginState>(
      'Test with invalid pwd format',
      build: () {
        return _loginBloc;
      },
      act: (bloc) => bloc.add(LoginPasswordChangedEvent(value: 'abc')),
      wait: const Duration(milliseconds: 500),
      expect: [
        LoginFailureState(error: [null, PWD_ERROR])
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'Test onLoginPasswordChanged function with invalid pwd format',
      build: () {
        _loginBloc.onLoginPasswordChanged('abc');
        return _loginBloc;
      },
      wait: const Duration(milliseconds: 500),
      expect: [
        LoginFailureState(error: [null, PWD_ERROR])
      ],
    );
  });

  //todo review
  group('Test LoginButtonPressedEvent', () {
    blocTest<LoginBloc, LoginState>(
      'Test onFormSubmitted function with valid credentials',
      build: () {
        _loginBloc.onFormSubmitted(LOGIN_EMAIL_HINT, LOGIN_PASSWORD_HINT);
        return _loginBloc;
      },
      wait: const Duration(milliseconds: 3500),
      expect: [
        LoginLoadingState(),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'Test LoginButtonPressedEvent with valid credentials',
      build: () {
        return _loginBloc;
      },
      act: (bloc) => bloc.add(LoginButtonPressedEvent(
          user: User(
              emailAddress: LOGIN_EMAIL_HINT, password: LOGIN_PASSWORD_HINT))),
      wait: const Duration(milliseconds: 3500),
      expect: [
        LoginLoadingState(),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'Test onFormSubmitted function with invalid credentials',
      build: () {
        _loginBloc.onFormSubmitted('abc@123.com', 'qwer54321');
        return _loginBloc;
      },
      wait: const Duration(milliseconds: 3500),
      expect: [
        LoginLoadingState(),
        LoginFailureState(error: [null, null]),
        LoginFormFailureState(error: LOGIN_INVALID_CREDENTIALS),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'Test LoginButtonPressedEvent with invalid credentials',
      build: () {
        return _loginBloc;
      },
      act: (bloc) => bloc.add(LoginButtonPressedEvent(
          user: User(emailAddress: 'abc@123.com', password: 'qwer54321'))),
      wait: const Duration(milliseconds: 3500),
      expect: [
        LoginLoadingState(),
        LoginFailureState(error: [null, null]),
        LoginFormFailureState(error: LOGIN_INVALID_CREDENTIALS),
      ],
    );
  });
}
