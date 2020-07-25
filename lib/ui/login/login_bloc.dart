import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/data/entities/user.dart';
import 'package:flutterapp/extension/extension.dart';
import 'package:flutterapp/ui/authentication/authentication_bloc.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationBloc authBloc;

  final List<String> _list = List(2);

  LoginBloc({@required this.authBloc})
      : assert(authBloc != null),
        super(LoginInitialState());

  @override
  Stream<Transition<LoginEvent, LoginState>> transformEvents(
    Stream<LoginEvent> events,
    Stream<Transition<LoginEvent, LoginState>> Function(
      LoginEvent event,
    )
        transitionFn,
  ) {
    return events
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap(transitionFn);
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginEmailChangedEvent) {
      yield* _mapStateOfLoginEmailChanged(event.value);
    }

    if (event is LoginPasswordChangedEvent) {
      yield* _mapStateOfPasswordEmailChanged(event.value);
    }

    if (event is LoginButtonPressedEvent) {
      yield* _mapStateOnButtonPressed(event.user);
    }
  }

  Stream<LoginState> _mapStateOfLoginEmailChanged(String value) async* {
    _list[0] = !value.isEmailValid() ? EMAIL_ERROR : null;
    yield !value.isEmailValid()
        ? LoginFailureState(error: _list)
        : LoginEditingState();
  }

  Stream<LoginState> _mapStateOfPasswordEmailChanged(String value) async* {
    _list[1] = !value.isPasswordValid() ? PWD_ERROR : null;
    print('pwd error: ${_list[1]}');
    yield !value.isPasswordValid()
        ? LoginFailureState(error: _list)
        : LoginEditingState();
  }

  Stream<LoginState> _mapStateOnButtonPressed(User user) async* {
    yield LoginLoadingState();
    await Future.delayed(Duration(seconds: 3), () {}); // simulation
    if (isCredentialValid(user)) {
      authBloc.add(AuthenticationLoggedInEvent(user: user));
    } else {
      if (!user.emailAddress.isEmailValid()) {
        _list[0] = EMAIL_ERROR;
      }
      if (!user.password.isPasswordValid()) {
        _list[1] = PWD_ERROR;
      }
      yield LoginFailureState(error: [_list[0], _list[1]]);
      yield LoginFormFailureState(error: Exception(LOGIN_INVALID_CREDENTIALS));
    }
  }

  bool isCredentialValid(User user) =>
      user.emailAddress == LOGIN_EMAIL_HINT &&
      user.password == LOGIN_PASSWORD_HINT;

  void onLoginEmailChanged(String value) {
    add(LoginEmailChangedEvent(value: value));
  }

  void onLoginPasswordChanged(String value) {
    add(LoginPasswordChangedEvent(value: value));
  }

  void onFormSubmitted(String email, String pwd) {
    if (state is! LoginLoadingState) {
      add(LoginButtonPressedEvent(
          user: User(emailAddress: email, password: pwd)));
    }
  }
}

///EVENTS///
@immutable
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginEmailChangedEvent extends LoginEvent {
  final String value;

  const LoginEmailChangedEvent({this.value});

  @override
  List<Object> get props => [value];
}

class LoginPasswordChangedEvent extends LoginEvent {
  final String value;

  const LoginPasswordChangedEvent({this.value});

  @override
  List<Object> get props => [value];
}

class LoginButtonPressedEvent extends LoginEvent {
  final User user;

  const LoginButtonPressedEvent({this.user});

  @override
  List<Object> get props => [user];
}

///STATES///
@immutable
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitialState extends LoginState {}

class LoginEditingState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginFailureState extends LoginState {
  final List<String> error;

  const LoginFailureState({@required this.error});

  @override
  List<Object> get props => [error];
}

class LoginFormFailureState extends LoginState {
  final Exception error;

  const LoginFormFailureState({@required this.error});

  @override
  List<Object> get props => [error];
}
