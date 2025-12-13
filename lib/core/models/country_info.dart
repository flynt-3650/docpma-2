class CountryInfo {
  final String name;
  final String? capital;
  final String? flagPng;
  final String? cca2;

  const CountryInfo({
    required this.name,
    this.capital,
    this.flagPng,
    this.cca2,
  });

  @override
  String toString() =>
      'CountryInfo(name: $name, capital: $capital, cca2: $cca2)';
}
