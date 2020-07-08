// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModelEntity _$ModelEntityFromJson(Map<String, dynamic> json) {
  return ModelEntity(
    author: json['author'] as String,
    name: json['name'] as String,
    avatar: json['avatar'] as String,
    url: json['url'] as String,
    description: json['description'] as String,
    language: json['language'] as String,
    languageColor: json['languageColor'] as String,
    stars: json['stars'] as int,
    forks: json['forks'] as int,
    currentPeriodStars: json['currentPeriodStars'] as int,
    builtBy: (json['builtBy'] as List)
        ?.map((e) =>
            e == null ? null : ModelChild.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ModelEntityToJson(ModelEntity instance) =>
    <String, dynamic>{
      'author': instance.author,
      'name': instance.name,
      'avatar': instance.avatar,
      'url': instance.url,
      'description': instance.description,
      'language': instance.language,
      'languageColor': instance.languageColor,
      'stars': instance.stars,
      'forks': instance.forks,
      'currentPeriodStars': instance.currentPeriodStars,
      'builtBy': instance.builtBy,
    };
