import 'package:json_annotation/json_annotation.dart';

part 'country_dto.g.dart';

/// Minimal DTO for REST Countries v3.1
@JsonSerializable()
class CountryDTO {
  final CountryNameDTO? name;
  final List<String>? capital;

  /// Country code (e.g., RU)
  @JsonKey(name: 'cca2')
  final String? cca2;

  final CountryFlagsDTO? flags;

  const CountryDTO({this.name, this.capital, this.cca2, this.flags});

  factory CountryDTO.fromJson(Map<String, dynamic> json) =>
      _$CountryDTOFromJson(json);

  Map<String, dynamic> toJson() => _$CountryDTOToJson(this);
}

@JsonSerializable()
class CountryNameDTO {
  final String? common;

  const CountryNameDTO({this.common});

  factory CountryNameDTO.fromJson(Map<String, dynamic> json) =>
      _$CountryNameDTOFromJson(json);

  Map<String, dynamic> toJson() => _$CountryNameDTOToJson(this);
}

@JsonSerializable()
class CountryFlagsDTO {
  final String? png;
  final String? svg;

  const CountryFlagsDTO({this.png, this.svg});

  factory CountryFlagsDTO.fromJson(Map<String, dynamic> json) =>
      _$CountryFlagsDTOFromJson(json);

  Map<String, dynamic> toJson() => _$CountryFlagsDTOToJson(this);
}
