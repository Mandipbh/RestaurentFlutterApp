class Restaurant {
  final String id;
  final String name;
  final String imageUrl;
  final String address;

  Restaurant({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.address,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'].toString(),
      name: json['name'],
      imageUrl: json['image_url'] ?? '',
      address: json['location'] ?? '',
    );
  }
}
