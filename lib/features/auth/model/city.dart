class City {
  final String name;
  final String country;

  City({
    required this.name,
    required this.country,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'],
      country: json['countryName'],
    );
  }
}
