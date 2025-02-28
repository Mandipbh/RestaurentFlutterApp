class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String createdAt;
  final String lastSignInAt;
  final String address;
  final String phone;
  final String? imageUrl;

  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.createdAt,
    required this.lastSignInAt,
    required this.address,
    required this.phone,
    this.imageUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      fullName: map['full_name'] ?? 'Guest User',
      address: map['address'] ?? 'Guest address',
      phone: map['phone'] ?? 'phone',
      imageUrl: map['profile_pic'], // Updated to use profile_pic column
      createdAt: map['created_at'] ?? '',
      lastSignInAt: map['last_sign_in_at'] ?? '',
    );
  }
}

