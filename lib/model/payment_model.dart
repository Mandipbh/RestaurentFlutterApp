class PaymentModel {
  final String id;
  final double amount;
  final String method;
  final String status;
  final DateTime createdAt;

  PaymentModel({
    required this.id,
    required this.amount,
    required this.method,
    required this.status,
    required this.createdAt,
  });

  // Factory method to convert JSON to PaymentModel
  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      amount: (json['amount'] as num).toDouble(),
      method: json['payment_method'] ?? 'Unknown',
      status: json['payment_status'] ?? 'Pending',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}