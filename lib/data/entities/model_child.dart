import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'model_child.g.dart';

@JsonSerializable()
@immutable
class ModelChild extends Equatable {
  @JsonKey(name: 'username')
  final String username;
  @JsonKey(name: 'href')
  final String href;
  @JsonKey(name: 'avatar')
  final String avatar;

  ModelChild({this.username, this.href, this.avatar});

  factory ModelChild.fromJson(Map<String, dynamic> json) =>
      _$ModelChildFromJson(json);

  Map<String, dynamic> toJson() => _$ModelChildToJson(this);

  @override
  List<Object> get props => [username, href, avatar];

  @override
  bool get stringify => true;
}
