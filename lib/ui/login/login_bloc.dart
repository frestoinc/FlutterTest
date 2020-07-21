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

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String get _email => emailController.text.trim();

  String get _pwd => passwordController.text.trim();

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
      yield* _mapStateOfLoginEmailChanged();
    }

    if (event is LoginPasswordChangedEvent) {
      yield* _mapStateOfPasswordEmailChanged();
    }

    if (event is LoginButtonPressedEvent) {
      yield* _mapStateOnButtonPressed();
    }
  }

  Stream<LoginState> _mapStateOfLoginEmailChanged() async* {
    _list[0] = !_email.isEmailValid() ? EMAIL_ERROR : null;
    yield !_email.isEmailValid()
        ? LoginFailureState(error: [_list[0], _list[1]])
        : LoginEditingState();
  }

  Stream<LoginState> _mapStateOfPasswordEmailChanged() async* {
    _list[1] = !_pwd.isPasswordValid() ? PWD_ERROR : null;
    yield !_pwd.isPasswordValid()
        ? LoginFailureState(error: [_list[0], _list[1]])
        : LoginEditingState();
  }

  Stream<LoginState> _mapStateOnButtonPressed() async* {
    yield LoginLoadingState();
    await Future.delayed(Duration(seconds: 3), () {}); // simulation
    if (isCredentialValid()) {
      authBloc.add(AuthenticationLoggedInEvent(
          user: User(emailAddress: _email, password: _pwd)));
    } else {
      if (!_email.isEmailValid()) {
        _list[0] = EMAIL_ERROR;
      }
      if (!_pwd.isPasswordValid()) {
        _list[1] = PWD_ERROR;
      }
      yield LoginFailureState(error: [_list[0], _list[1]]);
      yield LoginFormFailureState(error: Exception(LOGIN_INVALID_CREDENTIALS));
    }
  }

  bool isCredentialValid() =>
      _email == LOGIN_EMAIL_HINT && _pwd == LOGIN_PASSWORD_HINT;

  void onLoginEmailChanged() {
    add(LoginEmailChangedEvent());
  }

  void onLoginPasswordChanged() {
    add(LoginPasswordChangedEvent());
  }

  void onFormSubmitted() {
    if (state is! LoginLoadingState) {
      add(LoginButtonPressedEvent());
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

class LoginEmailChangedEvent extends LoginEvent {}

class LoginPasswordChangedEvent extends LoginEvent {}

class LoginButtonPressedEvent extends LoginEvent {}

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
}

class LoginFormFailureState extends LoginState {
  final Exception error;

  const LoginFormFailureState({@required this.error});
}
