import 'dart:convert';

class Pengaduan {
  final String namaKorban;
  final String alamat;
  final String aduan;
  final String kategoriKekerasan;
  final String harapan;
  final List<String> evidenceUrls;
  final List<String> evidencePaths;

  Pengaduan({
    required this.namaKorban,
    required this.alamat,
    required this.aduan,
    required this.kategoriKekerasan,
    required this.harapan,
    required this.evidenceUrls,
    required this.evidencePaths,
  });

  factory Pengaduan.fromJson(Map<String, dynamic> json) {
    return Pengaduan(
      namaKorban: json['namaKorban'] ?? '',
      alamat: json['alamat'] ?? '',
      aduan: json['aduan'] ?? '',
      kategoriKekerasan: json['kategoriKekerasan'] ?? '',
      harapan: json['harapan'] ?? '',
      evidenceUrls: List<String>.from(
          json['evidenceUrls'] is String ? jsonDecode(json['evidenceUrls']) : json['evidenceUrls'] ?? []),
      evidencePaths: List<String>.from(
          json['evidencePaths'] is String ? jsonDecode(json['evidencePaths']) : json['evidencePaths'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'namaKorban': namaKorban,
      'alamat': alamat,
      'aduan': aduan,
      'kategoriKekerasan': kategoriKekerasan,
      'harapan': harapan,
      'evidenceUrls': evidenceUrls,
      'evidencePaths': evidencePaths,
    };
  }

  Pengaduan copyWith({
    String? namaKorban,
    String? alamat,
    String? aduan,
    String? kategoriKekerasan,
    String? harapan,
    List<String>? evidenceUrls,
    List<String>? evidencePaths,
  }) {
    return Pengaduan(
      namaKorban: namaKorban ?? this.namaKorban,
      alamat: alamat ?? this.alamat,
      aduan: aduan ?? this.aduan,
      kategoriKekerasan: kategoriKekerasan ?? this.kategoriKekerasan,
      harapan: harapan ?? this.harapan,
      evidenceUrls: evidenceUrls ?? this.evidenceUrls,
      evidencePaths: evidencePaths ?? this.evidencePaths,
    );
  }
}
