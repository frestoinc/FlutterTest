import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/extension/constants.dart';
import 'package:flutterapp/extension/string.dart';
import 'package:rxdart/rxdart.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String get _email => emailController.text.trim();

  String get _pwd => passwordController.text.trim();

  final List<String> _list = new List(2);

  LoginBloc.init() : super(LoginInitial()) {
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
      return (event is! LoginEmailChanged && event is! LoginPasswordChanged);
    });

    final debounceStream = events.where((event) {
      return (event is LoginEmailChanged || event is LoginPasswordChanged);
    }).timeout(Duration(milliseconds: 500));

    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginEmailChanged) {
      yield* _mapStateOfLoginEmailChanged();
    } else if (event is LoginPasswordChanged) {
      yield* _mapStateOfPasswordEmailChanged();
    } else if (event is LoginButtonPressed) {
      yield* _mapStateOnButtonPressed();
    }
  }

  Stream<LoginState> _mapStateOfLoginEmailChanged() async* {
    _list[0] = !_email.isEmailValid() ? EMAIL_ERROR : null;
    yield !_email.isEmailValid()
        ? LoginFailure(error: [_list[0], _list[1]])
        : LoginEditing();
  }

  Stream<LoginState> _mapStateOfPasswordEmailChanged() async* {
    _list[1] = !_pwd.isPasswordValid() ? PWD_ERROR : null;
    yield !_pwd.isPasswordValid()
        ? LoginFailure(error: [_list[0], _list[1]])
        : LoginEditing();
  }

  Stream<LoginState> _mapStateOnButtonPressed() async* {
    yield LoginLoading();
    await Future.delayed(Duration(seconds: 3), () {}); // simulation
    if (_email == LOGIN_EMAIL_HINT && _pwd == LOGIN_PASSWORD_HINT) {
      print("ALL OK!");
      yield LoginSuccess();
    } else {
      if (!_email.isEmailValid()) {
        _list[0] = EMAIL_ERROR;
      }
      if (!_pwd.isPasswordValid()) {
        _list[1] = PWD_ERROR;
      }
      yield LoginFailure(error: [_list[0], _list[1]]);
    }
  }

  void onLoginEmailChanged() {
    this.add(LoginEmailChanged());
  }

  void onLoginPasswordChanged() {
    this.add(LoginPasswordChanged());
  }

  void onFormSubmitted() {
    if (state is! LoginLoading) {
      this.add(LoginButtonPressed());
    }
  }

  @override
  Future<Function> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
