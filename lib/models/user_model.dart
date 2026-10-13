// lib/models/user_model.dart

class UserModel {
  final String id;
  final String name;
  final String role; // 'admin' | 'petugas' | 'viewer'

  UserModel({
    required this.id,
    required this.name,
    required this.role,
  });

  // Firebase Ready: fromMap digunakan saat migrasi ke Firestore
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      role: map['role'] ?? 'viewer',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
    };
  }
}
