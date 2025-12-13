import '../../core/models/country_info.dart';
import '../../core/models/post.dart';
import '../repositories/network_demo_repository.dart';

/// Use-cases for PR13 networking demo.
class NetworkDemoUseCases {
  NetworkDemoUseCases(this._repo);

  final NetworkDemoRepository _repo;

  Future<List<Post>> getPosts({int userId = 1}) =>
      _repo.getPosts(userId: userId);

  Future<Post> createPost({int userId = 1}) {
    return _repo.createPost(
      userId: userId,
      title: 'PR13 demo post',
      body: 'Created from Flutter app using Dio + Retrofit',
    );
  }

  Future<Post> updatePostPut({int id = 1, int userId = 1}) {
    return _repo.updatePost(
      id: id,
      userId: userId,
      title: 'Updated via PUT (PR13)',
      body: 'Full update example',
    );
  }

  Future<Post> patchPostTitle({int id = 1}) {
    return _repo.patchPostTitle(id: id, title: 'Patched title (PR13)');
  }

  Future<void> deletePost({int id = 1}) => _repo.deletePost(id: id);

  Future<CountryInfo> getCountry(String name) => _repo.getCountryByName(name);
}
