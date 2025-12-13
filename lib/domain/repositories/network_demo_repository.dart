import '../../core/models/country_info.dart';
import '../../core/models/post.dart';

abstract class NetworkDemoRepository {
  Future<List<Post>> getPosts({required int userId});

  Future<Post> createPost({
    required int userId,
    required String title,
    required String body,
  });

  Future<Post> updatePost({
    required int id,
    required int userId,
    required String title,
    required String body,
  });

  Future<Post> patchPostTitle({required int id, required String title});

  Future<void> deletePost({required int id});

  Future<CountryInfo> getCountryByName(String name);
}
