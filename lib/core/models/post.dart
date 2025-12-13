class Post {
  final int? id;
  final int userId;
  final String title;
  final String body;

  const Post({
    required this.userId,
    required this.title,
    required this.body,
    this.id,
  });

  @override
  String toString() => 'Post(id: $id, userId: $userId, title: $title)';
}
