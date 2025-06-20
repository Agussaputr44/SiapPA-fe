/**
 * Model class for Artikel.
 * Represents an article with properties such as id, title, content, photo, and timestamps.
 */
class Artikel {
  final int? id;
  final String judul;
  final String isi;
  final String? foto;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Artikel({
    this.id,
    required this.judul,
    required this.isi,
    this.foto,
    this.createdAt,
    this.updatedAt,
  });

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
