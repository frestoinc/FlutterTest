import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'model_child.dart';

part 'model_entity.g.dart';

@JsonSerializable()
@immutable
class ModelEntity {
  @JsonKey(name: 'author')
  final String author;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'avatar')
  final String avatar;
  @JsonKey(name: 'url')
  final String url;
  @JsonKey(name: 'description')
  final String description;
  @JsonKey(name: 'language')
  final String language;
  @JsonKey(name: 'languageColor')
  final String languageColor;
  @JsonKey(name: 'stars')
  final int stars;
  @JsonKey(name: 'forks')
  final int forks;
  @JsonKey(name: 'currentPeriodStars')
  final int currentPeriodStars;
  @JsonKey(name: 'builtBy')
  final List<ModelChild> builtBy;

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

  @override
  String toString() => 'ModelEntity{'
      'author: $author, name: $name, avatar: $avatar, '
      'url: $url, description: $description, language: $language, '
      'languageColor: $languageColor, stars: $stars, forks: $forks, '
      'currentPeriodStars: $currentPeriodStars, builtBy: $builtBy}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModelEntity &&
          author == other.author &&
          name == other.name &&
          avatar == other.avatar &&
          url == other.url &&
          description == other.description &&
          language == other.language &&
          languageColor == other.languageColor &&
          stars == other.stars &&
          forks == other.forks &&
          currentPeriodStars == other.currentPeriodStars &&
          builtBy == other.builtBy;
}
