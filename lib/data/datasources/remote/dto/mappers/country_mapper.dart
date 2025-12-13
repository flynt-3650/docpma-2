import '../../../../../core/models/country_info.dart';
import '../country_dto.dart';

extension CountryMapper on CountryDTO {
  CountryInfo toModel() {
    return CountryInfo(
      name: name?.common ?? 'Unknown',
      capital: (capital == null || capital!.isEmpty) ? null : capital!.first,
      flagPng: flags?.png,
      cca2: cca2,
    );
  }
}
