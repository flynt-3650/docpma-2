import 'package:dio/dio.dart';

import '../../../../core/models/post.dart';
import '../../../../core/network/exceptions/network_exceptions.dart';
import '../dto/mappers/post_mapper.dart';
import 'json_placeholder_api.dart';

/// Remote datasource for JSONPlaceholder.
class JsonPlaceholderDataSource {
  JsonPlaceholderDataSource(this._api);

  final JsonPlaceholderApi _api;

  Future<List<Post>> getPosts({required int userId}) async {
    try {
      final dtos = await _api.getPosts(userId);
      return dtos.map((e) => e.toModel()).toList();
    } on DioException catch (e) {
      throw e.error ??
          const NetworkException('Ошибка при получении списка постов');
    } catch (e) {
      throw NetworkException('Ошибка при получении списка постов', data: e);
    }
  }

  Future<Post> createPost({
    required int userId,
    required String title,
    required String body,
  }) async {
    try {
      final dto = await _api.createPost({
        'userId': userId,
        'title': title,
        'body': body,
      });
      return dto.toModel();
    } on DioException catch (e) {
      throw e.error ?? const NetworkException('Ошибка при создании поста');
    } catch (e) {
      throw NetworkException('Ошибка при создании поста', data: e);
    }
  }

  Future<Post> updatePost({
    required int id,
    required int userId,
    required String title,
    required String body,
  }) async {
    try {
      final dto = await _api.updatePost(id, {
        'userId': userId,
        'title': title,
        'body': body,
      });
      return dto.toModel();
    } on DioException catch (e) {
      throw e.error ??
          const NetworkException('Ошибка при обновлении поста (PUT)');
    } catch (e) {
      throw NetworkException('Ошибка при обновлении поста (PUT)', data: e);
    }
  }

  Future<Post> patchPostTitle({required int id, required String title}) async {
    try {
      final dto = await _api.patchPost(id, {'title': title});
      return dto.toModel();
    } on DioException catch (e) {
      throw e.error ??
          const NetworkException('Ошибка при частичном обновлении (PATCH)');
    } catch (e) {
      throw NetworkException(
        'Ошибка при частичном обновлении (PATCH)',
        data: e,
      );
    }
  }

  Future<void> deletePost({required int id}) async {
    try {
      await _api.deletePost(id);
    } on DioException catch (e) {
      throw e.error ??
          const NetworkException('Ошибка при удалении поста (DELETE)');
    } catch (e) {
      throw NetworkException('Ошибка при удалении поста (DELETE)', data: e);
    }
  }
}
