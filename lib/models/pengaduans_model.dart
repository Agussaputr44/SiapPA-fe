import 'dart:convert';

/// Model class untuk Pengaduan (Complaint) dalam aplikasi.
///
/// Kelas ini merepresentasikan satu aduan yang dibuat oleh pengguna,
/// mencakup berbagai detail seperti:
/// - Nama korban
/// - Alamat korban
/// - Isi aduan
/// - Kategori kekerasan
/// - Harapan/permintaan dari pelapor
/// - Daftar URL bukti (evidence) yang sudah di-upload
/// - Daftar path bukti (misal: file lokal sebelum upload)
///
/// Fitur utama:
/// - Konversi dari/ke format JSON untuk kebutuhan serialisasi/deserialisasi data.
/// - Mendukung pembuatan salinan objek dengan data yang diperbarui melalui metode [copyWith].
///
/// Contoh penggunaan:
/// ```dart
/// final pengaduan = Pengaduan.fromJson(jsonData);
/// print(pengaduan.namaKorban);
/// ```
class Pengaduan {
  /// Nama korban yang dilaporkan dalam aduan.
  final String namaKorban;

  /// Alamat korban.
  final String alamat;

  /// Isi aduan yang disampaikan pelapor.
  final String aduan;

  /// Kategori kekerasan (misal: fisik, psikis, seksual).
  final String kategoriKekerasan;

  /// Harapan atau permintaan pelapor terhadap penanganan kasus.
  final String harapan;

  /// Daftar URL bukti yang di-upload (misal: ke server).
  final List<String> evidenceUrls;

  /// Daftar path bukti (misal: path file lokal sebelum di-upload).
  final List<String> evidencePaths;

  /// Membuat instance [Pengaduan] baru.
  Pengaduan({
    required this.namaKorban,
    required this.alamat,
    required this.aduan,
    required this.kategoriKekerasan,
    required this.harapan,
    required this.evidenceUrls,
    required this.evidencePaths,
  });

  /// Membuat objek [Pengaduan] dari map JSON.
  ///
  /// Mendukung input berupa list maupun string JSON array pada field evidenceUrls dan evidencePaths.
  factory Pengaduan.fromJson(Map<String, dynamic> json) {
    return Pengaduan(
      namaKorban: json['namaKorban'] ?? '',
      alamat: json['alamat'] ?? '',
      aduan: json['aduan'] ?? '',
      kategoriKekerasan: json['kategoriKekerasan'] ?? '',
      harapan: json['harapan'] ?? '',
      evidenceUrls: List<String>.from(json['evidenceUrls'] is String
          ? jsonDecode(json['evidenceUrls'])
          : json['evidenceUrls'] ?? []),
      evidencePaths: List<String>.from(json['evidencePaths'] is String
          ? jsonDecode(json['evidencePaths'])
          : json['evidencePaths'] ?? []),
    );
  }

  /// Mengubah objek [Pengaduan] menjadi map JSON.
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

  /// Membuat salinan objek [Pengaduan] dengan properti yang dapat diperbarui.
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