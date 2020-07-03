import 'package:flutterapp/extension/string.dart';

enum ValidationErrorEnum { INVALID_EMAIL, INVALID_PASSWORD }

class Validator {
  const Validator();

  Set<ValidationErrorEnum> validateEmail(String email) {
    return email.isEmailValid()
        ? const {}
        : {ValidationErrorEnum.INVALID_EMAIL};
  }

  Set<ValidationErrorEnum> validatePassword(String pwd) {
    return pwd.isPasswordValid()
        ? const {}
        : {ValidationErrorEnum.INVALID_PASSWORD};
  }
}
