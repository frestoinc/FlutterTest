import 'package:json_annotation/json_annotation.dart';

part 'model_child.g.dart';

@JsonSerializable()
class ModelChild {
  String username;
  String href;
  String avatar;

  ModelChild({this.username, this.href, this.avatar});

  factory ModelChild.fromJson(Map<String, dynamic> json) =>
      _$ModelChildFromJson(json);

  Map<String, dynamic> toJson() => _$ModelChildToJson(this);
}
