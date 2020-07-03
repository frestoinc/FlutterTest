import 'validation_error.dart';

String getMessage(Set<ValidationErrorEnum> errors) {
  if (null == errors || errors.isEmpty) {
    return null;
  }
  if (errors.contains(ValidationErrorEnum.INVALID_EMAIL)) {
    return 'Invalid email address';
  }
  if (errors.contains(ValidationErrorEnum.INVALID_PASSWORD)) {
    return 'Password must be at least 6 characters';
  }
  return null;
}

extension ValidationExtension on String {
  bool isPasswordValid() {
    return this.length >= 6;
  }

  bool isEmailValid() {
    const _emailRegExpString = r'[a-zA-Z0-9\+\.\_\%\-\+]{1,256}\@[a-zA-Z0-9]'
        r'[a-zA-Z0-9\-]{0,64}(\.[a-zA-Z0-9][a-zA-Z0-9\-]{0,25})+';
    return RegExp(_emailRegExpString, caseSensitive: false).hasMatch(this);
  }
}
