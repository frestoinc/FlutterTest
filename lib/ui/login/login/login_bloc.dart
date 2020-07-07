import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/extension/constants.dart';
import 'package:flutterapp/extension/string.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String get _email => emailController.text.trim();

  String get _pwd => passwordController.text.trim();

  //maybe need to store error here

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

    /*return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );*/
    return super.transformEvents(events, transitionFn);
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
    print("_mapStateOfLoginEmailChanged: $_email");
    yield !_email.isEmailValid()
        ? LoginFailure(error: [EMAIL_ERROR, null]) //todo
        : LoginEditing();
  }

  Stream<LoginState> _mapStateOfPasswordEmailChanged() async* {
    print("_mapStateOfPasswordEmailChanged: $_pwd");
    yield !_pwd.isPasswordValid()
        ? LoginFailure(error: [null, PWD_ERROR]) //todo
        : LoginEditing();
  }

  Stream<LoginState> _mapStateOnButtonPressed() async* {
    print("_mapStateOnButtonPressed: $_email, $_pwd");
    yield LoginLoading();
    await Future.delayed(Duration(seconds: 3), () {});

    if (_email == "root@gmail.com" && _pwd == "1q2w3e4r") {
      print("ALL OK!");
      yield LoginSuccess();
    } else {
      var list = new List<String>(2);
      if (!_email.isEmailValid()) {
        list[0] = EMAIL_ERROR;
      }
      if (!_pwd.isPasswordValid()) {
        list[1] = PWD_ERROR;
      }
      yield LoginFailure(error: list);
    }
  }

  /* Stream<LoginState> _mapStateOfError(
      String emailError, String passwordError) async* {
    print("error: $emailError, $passwordError");
    _emailError.add(emailError);
    _passwordError.add(passwordError);
    yield LoginFailure(null);
  }*/

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
