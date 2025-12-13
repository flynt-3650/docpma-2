import '../../../../../core/models/post.dart';
import '../post_dto.dart';

extension PostMapper on PostDTO {
  Post toModel() {
    return Post(
      id: id,
      userId: userId ?? 0,
      title: title ?? '',
      body: body ?? '',
    );
  }
}
