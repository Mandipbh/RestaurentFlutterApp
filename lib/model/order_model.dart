class OrderModel {
  final String id; // Keep ID as String
  final String status;
  final double totalPrice;
  final String createdAt;
  final String deliveryAdress;

  OrderModel({
    required this.id,
    required this.status,
    required this.totalPrice,
    required this.createdAt,
    required this.deliveryAdress,
  });

 
 
 
 
 
 
 
 

  factory OrderModel.fromJson(Map<String, dynamic> json) {
   return OrderModel(
   id: json['id'] ?? '', // ID is a String, no conversion needed
   status: json['status'] ?? 'Pending',
   deliveryAdress: json['delivery_address'] ?? '',
   totalPrice: double.tryParse(json['total_amount'].toString()) ?? 0.0,
   createdAt: json['created_at'] ?? '',
   );
 }
  
}