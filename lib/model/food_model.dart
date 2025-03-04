class FoodItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String categoryId;
  final double carbsGrams;
  final double fatGrams;
  final String restaurantId;

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.categoryId,
    required this.carbsGrams,
    required this.fatGrams,
    required this.restaurantId,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id']?.toString() ?? '',  
      name: json['name'] ?? 'Unknown',  
      description: json['description'] ?? 'No description available',
      price: (json['price'] as num?)?.toDouble() ?? 0.0, 
      imageUrl: json['image_url'] ?? '', 
      categoryId: json['category_id']?.toString() ?? '',
      carbsGrams: (json['carbs_grams'] as num?)?.toDouble() ?? 0.0,
      fatGrams: (json['fat_grams'] as num?)?.toDouble() ?? 0.0,
      restaurantId: json['restaurant_id']?.toString() ?? '',
    );
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
    };
  }














}