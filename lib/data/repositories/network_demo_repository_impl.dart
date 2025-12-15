import '../../core/models/country_info.dart';
import '../../core/models/post.dart';
import '../../domain/repositories/network_demo_repository.dart';
import '../datasources/remote/api/countries_datasource.dart';
import '../datasources/remote/api/json_placeholder_datasource.dart';

class NetworkDemoRepositoryImpl implements NetworkDemoRepository {
  NetworkDemoRepositoryImpl({
    required JsonPlaceholderDataSource jsonPlaceholder,
    required CountriesDataSource countries,
  }) : _jsonPlaceholder = jsonPlaceholder,
       _countries = countries;

  final JsonPlaceholderDataSource _jsonPlaceholder;
  final CountriesDataSource _countries;

  @override
  Future<List<Post>> getPosts({required int userId}) async {
    return await _jsonPlaceholder.getPosts(userId: userId);
  }

  @override
  Future<Post> createPost({
    required int userId,
    required String title,
    required String body,
  }) async {
    return await _jsonPlaceholder.createPost(
      userId: userId,
      title: title,
      body: body,
    );
  }

  @override
  Future<Post> updatePost({
    required int id,
    required int userId,
    required String title,
    required String body,
  }) async {
    return await _jsonPlaceholder.updatePost(
      id: id,
      userId: userId,
      title: title,
      body: body,
    );
  }

  @override
  Future<Post> patchPostTitle({required int id, required String title}) async {
    return await _jsonPlaceholder.patchPostTitle(id: id, title: title);
  }

  @override
  Future<void> deletePost({required int id}) async {
    await _jsonPlaceholder.deletePost(id: id);
  }

  @override
  Future<CountryInfo> getCountryByName(String name) async {
    final list = await _countries.getCountryByName(name);
    if (list.isEmpty) return const CountryInfo(name: 'Not found');
    return list.first;
  }
}
