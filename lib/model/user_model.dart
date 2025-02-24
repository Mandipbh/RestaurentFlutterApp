class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String createdAt;
  final String lastSignInAt;
  final String address;
  final String phone;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.createdAt,
    required this.lastSignInAt,
    required this.address,
    required this.phone
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      fullName: map['full_name'] ?? 'Guest User',
            address: map['address'] ?? 'Guest address',
            phone:map['phone'] ?? 'phone',

      createdAt: map['created_at'] ?? '',
      lastSignInAt: map['last_sign_in_at'] ?? '',
    );
  }
}