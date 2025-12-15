import 'package:dio/dio.dart';

import '../../../../core/models/country_info.dart';
import '../../../../core/network/exceptions/network_exceptions.dart';
import '../dto/mappers/country_mapper.dart';
import 'rest_countries_api.dart';

class CountriesDataSource {
  CountriesDataSource(this._api);

  final RestCountriesApi _api;

  Future<List<CountryInfo>> getCountryByName(String name) async {
    try {
      final dtos = await _api.getByName(name, 'name,capital,flags,cca2');
      return dtos.map((e) => e.toModel()).toList();
    } on DioException catch (e) {
      throw e.error ?? const NetworkException('Ошибка при получении страны');
    } catch (e) {
      throw NetworkException('Ошибка при получении страны', data: e);
    }
  }
}
