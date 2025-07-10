import 'dart:convert';

class PengaduansModel {
  final String namaKorban;
  final String alamat;
  final String aduan;
  final String kategoriKekerasan;
  final String korban;
  final String harapan;
  final List<String> evidencePaths;
  final DateTime createdAt; // ✅ Tambahkan ini

  PengaduansModel({
    required this.namaKorban,
    required this.alamat,
    required this.aduan,
    required this.kategoriKekerasan,
    required this.korban,
    required this.harapan,
    required this.evidencePaths,
    required this.createdAt, // ✅ Tambahkan ini
  });

    static List<String> parseStringList(dynamic value) {
    try {
      if (value == null) return [];

      if (value is String) {
        final decoded = jsonDecode(value);
        if (decoded is List) {
          return decoded.map((e) => e.toString()).toList();
        }
      }

      if (value is List) {
        return value.map((e) => e.toString()).toList();
      }

      return [];
    } catch (e) {
      print('❌ Error parsing evidencePaths: $e');
      return [];
    }
  }

  factory PengaduansModel.fromJson(Map<String, dynamic> json) {
    return PengaduansModel(
      namaKorban: json['namaKorban'] ?? '',
      alamat: json['alamat'] ?? '',
      aduan: json['aduan'] ?? '',
      kategoriKekerasan: json['kategoriKekerasan'] ?? '',
      korban: json['korban'] ?? '',
      harapan: json['harapan'] ?? '',
      evidencePaths: parseStringList(json['evidencePaths']),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(), // ✅ Parsing tanggal
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'namaKorban': namaKorban,
      'alamat': alamat,
      'aduan': aduan,
      'kategoriKekerasan': kategoriKekerasan,
      'korban': korban,
      'harapan': harapan,
      'evidencePaths': evidencePaths,
      'created_at': createdAt.toIso8601String(), // ✅ Export field
    };
  }
}
