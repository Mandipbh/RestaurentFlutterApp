class Restaurant {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final String cityName;
  final String description;
    final String location;


  Restaurant({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.cityName,
    required this.description,
        required this.location,

  });

  // Factory constructor to create a Restaurant from JSON
  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['image_url'] ?? '', // Avoid null errors
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      cityName: json['city_name'] ?? 'Unknown', // Handle null case
      description: json['description'] ?? 'No description available',
            location: json['location'] ?? 'No description available',

    );
  }

  // Convert Restaurant object to JSON (for inserting/updating Supabase)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
      'rating': rating,
      'city_name': cityName,
      'description': description,
    };
  }
}