class FoodItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String categoryId;
  final double carbsGrams;
  final double fatGrams;

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.categoryId,
    required this.carbsGrams,
    required this.fatGrams,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      price: json['price'].toDouble(),
      imageUrl: json['image_url'] ?? '',
      categoryId: json['category_id'],
      carbsGrams: json['carbs_grams'].toDouble() ?? 0.0,
      fatGrams: json['fat_grams'].toDouble(),
    );
  }
}
