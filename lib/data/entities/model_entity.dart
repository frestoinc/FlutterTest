import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/data/entities/model_child.dart';
import 'package:json_annotation/json_annotation.dart';

part 'model_entity.g.dart';

@JsonSerializable()
@immutable
class ModelEntity extends Equatable {
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
  List<Object> get props => [
        author,
        name,
        avatar,
        url,
        description,
        language,
        languageColor,
        stars,
        forks,
        currentPeriodStars,
        builtBy
      ];

  @override
  bool get stringify => true;
}
