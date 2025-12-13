import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../dto/country_dto.dart';

part 'rest_countries_api.g.dart';

@RestApi(baseUrl: 'https://restcountries.com/v3.1/')
abstract class RestCountriesApi {
  factory RestCountriesApi(Dio dio, {String baseUrl}) = _RestCountriesApi;

  /// Example:
  /// GET /name/russia?fields=name,capital,flags,cca2
  @GET('name/{name}')
  Future<List<CountryDTO>> getByName(
    @Path('name') String name,
    @Query('fields') String fields,
  );
}
