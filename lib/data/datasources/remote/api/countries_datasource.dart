import 'package:dio/dio.dart';

import '../../../../core/network/exceptions/network_exceptions.dart';
import '../dto/country_dto.dart';
import 'rest_countries_api.dart';

/// Remote datasource for REST Countries.
class CountriesDataSource {
  CountriesDataSource(this._api);

  final RestCountriesApi _api;

  Future<List<CountryDTO>> getCountryByName(String name) async {
    try {
      return await _api.getByName(name, 'name,capital,flags,cca2');
    } on DioException catch (e) {
      throw e.error ?? const NetworkException('Ошибка при получении страны');
    } catch (e) {
      throw NetworkException('Ошибка при получении страны', data: e);
    }
  }
}
