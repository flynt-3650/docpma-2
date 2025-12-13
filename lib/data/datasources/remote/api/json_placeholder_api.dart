import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../dto/post_dto.dart';

part 'json_placeholder_api.g.dart';

@RestApi(baseUrl: 'https://jsonplaceholder.typicode.com/')
abstract class JsonPlaceholderApi {
  factory JsonPlaceholderApi(Dio dio, {String baseUrl}) = _JsonPlaceholderApi;

  @GET('posts')
  Future<List<PostDTO>> getPosts(@Query('userId') int userId);

  @POST('posts')
  Future<PostDTO> createPost(@Body() Map<String, dynamic> post);

  @PUT('posts/{id}')
  Future<PostDTO> updatePost(
    @Path('id') int id,
    @Body() Map<String, dynamic> post,
  );

  @PATCH('posts/{id}')
  Future<PostDTO> patchPost(
    @Path('id') int id,
    @Body() Map<String, dynamic> updates,
  );

  @DELETE('posts/{id}')
  Future<void> deletePost(@Path('id') int id);
}
