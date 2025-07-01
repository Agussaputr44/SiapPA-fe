/// Widget utilitas untuk menampilkan pesan notifikasi (SnackBar) di seluruh aplikasi.
///
/// Menyediakan tiga tipe pesan:
/// - [showSuccess] : untuk notifikasi sukses.
/// - [showError] : untuk notifikasi error.
/// - [showInfo] : untuk notifikasi informasi.
///
/// Masing-masing pesan akan menampilkan ikon yang sesuai (check, error, info) dan warna latar belakang berbeda.
/// SnackBar ini menggunakan [SnackBarBehavior.floating] agar tampil melayang di atas konten.
///
/// Contoh penggunaan:
/// ```dart
/// MessagesWidget.showSuccess(context, "Berhasil disimpan!");
/// MessagesWidget.showError(context, "Terjadi kesalahan!");
/// MessagesWidget.showInfo(context, "Informasi tambahan.");
/// ```
import 'package:flutter/material.dart';

class MessagesWidget {
  /// Menampilkan SnackBar sukses dengan ikon check dan warna hijau.
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Menampilkan SnackBar error dengan ikon error dan warna merah.
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Menampilkan SnackBar informasi dengan ikon info dan warna biru.
  static void showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}