// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_child.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModelChild _$ModelChildFromJson(Map<String, dynamic> json) {
  return ModelChild(
    username: json['username'] as String,
    href: json['href'] as String,
    avatar: json['avatar'] as String,
  );
}

Map<String, dynamic> _$ModelChildToJson(ModelChild instance) =>
    <String, dynamic>{
      'username': instance.username,
      'href': instance.href,
      'avatar': instance.avatar,
    };
