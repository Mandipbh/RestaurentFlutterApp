import 'package:uuid/uuid.dart';

class AllFood {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String categoryId;
  final double carbsGrams;
  final double fatGrams;
  final String restaurantId;
  final String sourceTable;

  AllFood({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.categoryId,
    required this.carbsGrams,
    required this.fatGrams,
    required this.restaurantId,
    required this.sourceTable,
  });

  // Generate UUID if the ID is not a valid UUID
  factory AllFood.fromJson(Map<String, dynamic> json) {
    return AllFood(
      id: _validateUUID(json['id'].toString()), // Ensure valid UUID
      name: json['name'] ?? 'Unknown',
      description: json['description'] ?? 'No description available',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image_url'] ?? '',
      categoryId: json['category_id'].toString(),
      carbsGrams: (json['carbs_grams'] as num?)?.toDouble() ?? 0.0,
      fatGrams: (json['fat_grams'] as num?)?.toDouble() ?? 0.0,
      restaurantId: json['restaurant_id'].toString(),
      sourceTable: json['source_table'] ?? 'unknown',
    );
  }

  static String _validateUUID(String id) {
    if (id.length == 36) {
      return id; // Already a valid UUID
    } else {
      return const Uuid().v4(); // Generate a new UUID
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'category_id': categoryId,
      'carbs_grams': carbsGrams,
      'fat_grams': fatGrams,
      'restaurant_id': restaurantId,
      'source_table': sourceTable,
    };
  }
}