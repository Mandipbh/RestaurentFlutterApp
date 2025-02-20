class CategoryItem {
  final String id;
  final String name;
  final String imageUrl;
  final double createdAt;


  CategoryItem({
    required this.id,
    required this.name,

    required this.imageUrl,
    required this.createdAt,
  });

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      id: json['id'],
      name: json['name'],
    
      imageUrl: json['image_url'] ?? '',
      createdAt: json['created_at'],
    );
  }
}
