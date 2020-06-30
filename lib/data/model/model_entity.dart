import 'package:json_annotation/json_annotation.dart';

import 'model_child.dart';

part 'model_entity.g.dart';

@JsonSerializable()
class ModelEntity {
  String author;
  String name;
  String avatar;
  String url;
  String description;
  String language;
  String languageColor;
  int stars;
  int forks;
  int currentPeriodStars;
  List<ModelChild> builtBy;

  ModelEntity(
      {this.author,
      this.name,
      this.avatar,
      this.url,
      this.description,
      this.language,
      this.languageColor,
      this.stars,
      this.forks,
      this.currentPeriodStars,
      this.builtBy});

  factory ModelEntity.fromJson(Map<String, dynamic> json) =>
      _$ModelEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ModelEntityToJson(this);
}
