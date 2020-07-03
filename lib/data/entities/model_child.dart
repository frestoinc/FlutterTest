import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'model_child.g.dart';

@JsonSerializable()
@immutable
class ModelChild {
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
  String toString() =>
      'ModelChild{username: $username, href: $href, avatar: $avatar}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelChild &&
          username == other.username &&
          href == other.href &&
          avatar == other.avatar;
}
