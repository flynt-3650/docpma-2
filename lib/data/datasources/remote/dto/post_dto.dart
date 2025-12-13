import 'package:json_annotation/json_annotation.dart';

part 'post_dto.g.dart';

/// DTO for JSONPlaceholder /posts
@JsonSerializable()
class PostDTO {
  final int? userId;
  final int? id;
  final String? title;
  final String? body;

  const PostDTO({this.userId, this.id, this.title, this.body});

  factory PostDTO.fromJson(Map<String, dynamic> json) =>
      _$PostDTOFromJson(json);

  Map<String, dynamic> toJson() => _$PostDTOToJson(this);
}
