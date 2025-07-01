/// Model class untuk Artikel.
///
/// Kelas ini merepresentasikan data artikel dalam aplikasi,
/// mencakup berbagai properti seperti:
/// - [id]: ID unik artikel (opsional, bisa null jika artikel baru belum disimpan di database)
/// - [judul]: Judul artikel
/// - [isi]: Isi atau konten utama artikel
/// - [foto]: URL/path foto artikel (opsional)
/// - [createdAt]: Waktu pembuatan artikel (opsional)
/// - [updatedAt]: Waktu update terakhir artikel (opsional)
///
/// Fitur utama:
/// - Konversi dari/ke format JSON untuk kebutuhan serialisasi/deserialisasi data.
/// - Mendukung pembuatan salinan objek dengan data yang diperbarui melalui metode [copyWith].
///
/// Contoh penggunaan:
/// ```dart
/// final artikel = Artikel.fromJson(jsonData);
/// print(artikel.judul);
/// ```
class Artikel {
  /// ID unik artikel (opsional).
  final int? id;

  /// Judul artikel.
  final String judul;

  /// Isi/konten utama artikel.
  final String isi;

  /// URL atau path foto artikel (opsional).
  final String? foto;

  /// Timestamp pembuatan artikel (opsional).
  final DateTime? createdAt;

  /// Timestamp update terakhir artikel (opsional).
  final DateTime? updatedAt;

  /// Membuat instance [Artikel] baru.
  Artikel({
    this.id,
    required this.judul,
    required this.isi,
    this.foto,
    this.createdAt,
    this.updatedAt,
  });

  /// Membuat objek [Artikel] dari map JSON.
  factory Artikel.fromJson(Map<String, dynamic> json) {
    return Artikel(
      id: json['id'],
      judul: json['judul'] ?? '',
      isi: json['isi'] ?? '',
      foto: json['foto'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  /// Membuat salinan objek [Artikel] dengan properti yang dapat diperbarui.
  Artikel copyWith({
    int? id,
    String? judul,
    String? isi,
    String? foto,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Artikel(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      isi: isi ?? this.isi,
      foto: foto ?? this.foto,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Mengubah objek [Artikel] menjadi map JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'isi': isi,
      'foto': foto,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}