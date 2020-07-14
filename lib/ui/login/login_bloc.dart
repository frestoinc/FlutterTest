import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/extension/constants.dart';
import 'package:flutterapp/extension/string.dart';
import 'package:flutterapp/ui/home/home_ui.dart';
import 'package:rxdart/rxdart.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String get _email => emailController.text.trim();

  String get _pwd => passwordController.text.trim();

  final List<String> _list = new List(2);

  LoginBloc() : super(LoginInitialState()) {
    emailController.addListener(() {
      this.onLoginEmailChanged();
    });
    passwordController.addListener(() {
      this.onLoginPasswordChanged();
    });
  }

  @override
  Stream<Transition<LoginEvent, LoginState>> transformEvents(
      Stream<LoginEvent> events,
      TransitionFunction<LoginEvent, LoginState> transitionFn) {
    final nonDebounceStream = events.where((event) {
      return (event is! LoginEmailChangedEvent &&
          event is! LoginPasswordChangedEvent);
    });

    final debounceStream = events.where((event) {
      return (event is LoginEmailChangedEvent ||
          event is LoginPasswordChangedEvent);
    }).timeout(Duration(milliseconds: 500));

    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginEmailChangedEvent) {
      yield* _mapStateOfLoginEmailChanged();
    } else if (event is LoginPasswordChangedEvent) {
      yield* _mapStateOfPasswordEmailChanged();
    } else if (event is LoginButtonPressedEvent) {
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
    if (_email == LOGIN_EMAIL_HINT && _pwd == LOGIN_PASSWORD_HINT) {
      yield LoginSuccessState();
    } else {
      if (!_email.isEmailValid()) {
        _list[0] = EMAIL_ERROR;
      }
      if (!_pwd.isPasswordValid()) {
        _list[1] = PWD_ERROR;
      }
      yield LoginFailureState(error: [_list[0], _list[1]]);
      yield LoginFormFailureState();
    }
  }

  void onLoginEmailChanged() {
    this.add(LoginEmailChangedEvent());
  }

  void onLoginPasswordChanged() {
    this.add(LoginPasswordChangedEvent());
  }

  void onFormSubmitted() {
    if (state is! LoginLoadingState) {
      this.add(LoginButtonPressedEvent());
    }
  }

  void navigate(BuildContext context) {
    //todo save details to shared preference
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  Future<Function> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
