import 'package:dio/dio.dart';

import '../../../../core/network/exceptions/network_exceptions.dart';
import '../dto/post_dto.dart';
import 'json_placeholder_api.dart';

/// Remote datasource for JSONPlaceholder.
class JsonPlaceholderDataSource {
  JsonPlaceholderDataSource(this._api);

  final JsonPlaceholderApi _api;

  Future<List<PostDTO>> getPosts({required int userId}) async {
    try {
      return await _api.getPosts(userId);
    } on DioException catch (e) {
      throw e.error ??
          const NetworkException('Ошибка при получении списка постов');
    } catch (e) {
      throw NetworkException('Ошибка при получении списка постов', data: e);
    }
  }

  Future<PostDTO> createPost({
    required int userId,
    required String title,
    required String body,
  }) async {
    try {
      return await _api.createPost({
        'userId': userId,
        'title': title,
        'body': body,
      });
    } on DioException catch (e) {
      throw e.error ?? const NetworkException('Ошибка при создании поста');
    } catch (e) {
      throw NetworkException('Ошибка при создании поста', data: e);
    }
  }

  Future<PostDTO> updatePost({
    required int id,
    required int userId,
    required String title,
    required String body,
  }) async {
    try {
      return await _api.updatePost(id, {
        'userId': userId,
        'title': title,
        'body': body,
      });
    } on DioException catch (e) {
      throw e.error ??
          const NetworkException('Ошибка при обновлении поста (PUT)');
    } catch (e) {
      throw NetworkException('Ошибка при обновлении поста (PUT)', data: e);
    }
  }

  Future<PostDTO> patchPostTitle({
    required int id,
    required String title,
  }) async {
    try {
      return await _api.patchPost(id, {'title': title});
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
