import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
@immutable
class User extends Equatable {
  final String emailAddress;
  final String password;

  const User({this.emailAddress, this.password});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object> get props => [
        emailAddress,
        password,
      ];

  @override
  bool get stringify => true;
}
