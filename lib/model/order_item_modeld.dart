class OrderItemModel {
  final String id;
  final String orderId;
  final String? foodId;
  final String? recommendedId;
  final String? combinationId;
  final String name;
  final int quantity;
  final double price;

  OrderItemModel({
    required this.id,
    required this.orderId,
    this.foodId,
    this.recommendedId,
    this.combinationId,
    required this.name,
    required this.quantity,
    required this.price,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      foodId: json['food_id'] as String?,
      recommendedId: json['recommended_breakfast_id'] as String?,
      combinationId: json['combination_breakfast_id'] as String?,
      name: json['order_name'] ?? "Unknown",
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
    );
  }
}