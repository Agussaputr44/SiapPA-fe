/**
 * UsersModel class represents a user in the system.
 * It contains user details such as id, name, email, phone, profile picture,
 */
class UsersModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? fotoProfile;
  final String role;

  UsersModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.fotoProfile,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'foto_profile': fotoProfile,
      'role': role,
    };
  }

  factory UsersModel.fromJson(Map<String, dynamic> json) {
    return UsersModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      fotoProfile: json['foto_profile'],
      role: json['role'] ?? '',
    );
  }

  UsersModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? fotoProfile,
    String? role,
  }) {
    return UsersModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      fotoProfile: fotoProfile ?? this.fotoProfile,
      role: role ?? this.role,
    );
  }
}
