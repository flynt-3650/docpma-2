// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostDTO _$PostDTOFromJson(Map<String, dynamic> json) => PostDTO(
  userId: (json['userId'] as num?)?.toInt(),
  id: (json['id'] as num?)?.toInt(),
  title: json['title'] as String?,
  body: json['body'] as String?,
);

Map<String, dynamic> _$PostDTOToJson(PostDTO instance) => <String, dynamic>{
  'userId': instance.userId,
  'id': instance.id,
  'title': instance.title,
  'body': instance.body,
};
