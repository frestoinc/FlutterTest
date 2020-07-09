import 'package:flutter/material.dart';

extension ValidationExtension on String {
  bool isPasswordValid() {
    return this.length >= 6;
  }

  bool isEmailValid() {
    const _emailRegExpString = r'[a-zA-Z0-9\+\.\_\%\-\+]{1,256}\@[a-zA-Z0-9]'
        r'[a-zA-Z0-9\-]{0,64}(\.[a-zA-Z0-9][a-zA-Z0-9\-]{0,25})+';
    return this != null &&
        RegExp(_emailRegExpString, caseSensitive: false).hasMatch(this);
  }

  Color parseColor() {
    return Color(int.parse(this.replaceFirst(new RegExp(r'#'), "0x")));
  }
}
