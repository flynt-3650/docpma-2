// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountryDTO _$CountryDTOFromJson(Map<String, dynamic> json) => CountryDTO(
  name: json['name'] == null
      ? null
      : CountryNameDTO.fromJson(json['name'] as Map<String, dynamic>),
  capital: (json['capital'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  cca2: json['cca2'] as String?,
  flags: json['flags'] == null
      ? null
      : CountryFlagsDTO.fromJson(json['flags'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CountryDTOToJson(CountryDTO instance) =>
    <String, dynamic>{
      'name': instance.name,
      'capital': instance.capital,
      'cca2': instance.cca2,
      'flags': instance.flags,
    };

CountryNameDTO _$CountryNameDTOFromJson(Map<String, dynamic> json) =>
    CountryNameDTO(common: json['common'] as String?);

Map<String, dynamic> _$CountryNameDTOToJson(CountryNameDTO instance) =>
    <String, dynamic>{'common': instance.common};

CountryFlagsDTO _$CountryFlagsDTOFromJson(Map<String, dynamic> json) =>
    CountryFlagsDTO(png: json['png'] as String?, svg: json['svg'] as String?);

Map<String, dynamic> _$CountryFlagsDTOToJson(CountryFlagsDTO instance) =>
    <String, dynamic>{'png': instance.png, 'svg': instance.svg};
