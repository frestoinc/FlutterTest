import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutterapp/extension/constants.dart';
import 'package:flutterapp/extension/string.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stacked/stacked.dart';

class LoginViewModel extends BaseViewModel {
  /*String _emailAddress;
  String _password;

  String emailError;
  String passwordError;*/

  final emailAddress = TextEditingController();
  final password = TextEditingController();

  final _emailError = BehaviorSubject<String>();
  final _pwdError = BehaviorSubject<String>();
  final _visibilityPwdController = BehaviorSubject<bool>.seeded(false);

  Stream<String> get emailAddressStream => _emailError.stream;

  Stream<String> get passwordStream => _pwdError.stream;

  Stream<bool> get visibilityStream => _visibilityPwdController.stream;

  Sink<String> get emailErrorEvent => _emailError.sink;

  Sink<String> get pwdErrorEvent => _pwdError.sink;

  Sink<bool> get visibilityEvent => _visibilityPwdController.sink;

  void resetError(bool isEmail) {
    if (isEmail) {
      _emailError.add(null);
    } else {
      _pwdError.add(null);
    }
    notifyListeners();
  }

  void attemptLogin() {
    setBusy(true);
    print(emailAddress.text);
    print(password.text);
    if (!emailAddress.text.isEmailValid()) {
      _emailError.addError(EMAIL_ERROR);
    }

    if (!password.text.isPasswordValid()) {
      _pwdError.addError(PWD_ERROR);
    }
    setBusy(false);
    print("finish");
    notifyListeners();
  }

  @override
  bool get disposed => true;

  @override
  void dispose() {
    emailAddress.dispose();
    password.dispose();
    _visibilityPwdController.close();
    super.dispose();
  }
}
