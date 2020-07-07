import 'package:flutter/material.dart';

@immutable
class User {
  final String emailAddress;
  final String password;

  User(this.emailAddress, this.password);
}
