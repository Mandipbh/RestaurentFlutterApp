class City {
  final String id;
  final String name;
  final String? state;
  final String? country;

  City({
    required this.id,
    required this.name,
    required this.state,
    required this.country,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
    );
  }
}
