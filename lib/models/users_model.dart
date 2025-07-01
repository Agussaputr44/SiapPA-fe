/// UsersModel merepresentasikan entitas pengguna dalam sistem.
///
/// Kelas ini menyimpan detail pengguna seperti id, nama, email, nomor telepon, foto profil, dan peran (role).
/// 
/// Fitur utama:
/// - Konversi dari/ke format JSON untuk kebutuhan serialisasi/deserialisasi data.
/// - Mendukung pembuatan salinan objek dengan data yang diperbarui melalui metode [copyWith].
/// - Override untuk [toString], [==], dan [hashCode] agar mudah digunakan dalam debugging, perbandingan, serta koleksi.
///
/// Contoh penggunaan:
/// ```dart
/// final user = UsersModel.fromJson(jsonData);
/// print(user.name);
/// ```
class UsersModel {
  /// ID unik pengguna.
  final String id;

  /// Nama lengkap pengguna.
  final String name;

  /// Alamat email pengguna.
  final String email;

  /// Nomor telepon pengguna.
  final String phone;

  /// URL atau path foto profil pengguna (opsional).
  final String? fotoProfile;

  /// Peran pengguna dalam sistem (misal: admin, user).
  final String role;

  /// Membuat instance [UsersModel] baru.
  const UsersModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.fotoProfile,
    required this.role,
  });

  /// Mengubah objek [UsersModel] menjadi map JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'foto_profile': fotoProfile,
        'role': role,
      };

  /// Membuat objek [UsersModel] dari map JSON.
  factory UsersModel.fromJson(Map<String, dynamic> json) => UsersModel(
        id: json['id']?.toString() ?? '',
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        phone: json['phone'] ?? '',
        fotoProfile: json['foto_profile'],
        role: json['role'] ?? '',
      );

  /// Membuat salinan objek [UsersModel] dengan properti yang dapat diperbarui.
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

  @override
  String toString() {
    return 'UsersModel(id: $id, name: $name, email: $email, phone: $phone, fotoProfile: $fotoProfile, role: $role)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UsersModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          email == other.email &&
          phone == other.phone &&
          fotoProfile == other.fotoProfile &&
          role == other.role;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      email.hashCode ^
      phone.hashCode ^
      fotoProfile.hashCode ^
      role.hashCode;
}