/// Helper untuk menampilkan custom dialog konfirmasi yang reusable di seluruh aplikasi.
///
/// Fungsi ini akan memunculkan dialog konfirmasi dengan tampilan dan parameter yang bisa dikustomisasi
/// (judul, pesan, ikon, warna, teks tombol, dll.), serta mengembalikan hasil pilihan user (`true` jika konfirmasi,
/// `false` jika batal, dan `null` jika dialog ditutup tanpa memilih).
///
/// Cocok digunakan untuk berbagai kebutuhan konfirmasi (logout, hapus data, keluar aplikasi, dsb).
///
/// Contoh penggunaan:
/// ```dart
/// final result = await showCustomConfirmDialog(
///   context: context,
///   title: "Logout",
///   message: "Apakah Anda yakin ingin logout?",
///   confirmText: "Logout",
///   cancelText: "Batal",
///   icon: Icons.logout,
///   iconColor: Colors.red,
/// );
/// if (result == true) {
///   // lakukan aksi logout
/// }
/// ```
library;
import 'package:flutter/material.dart';
import '../views/widgets/confirm_dialog_widget.dart';

/// Menampilkan dialog konfirmasi dengan tampilan custom.
/// 
/// [context] - BuildContext untuk menampilkan dialog.
/// [title] - Judul dialog.
/// [message] - Pesan pada dialog.
/// [confirmText] - Teks tombol konfirmasi (default: "Yes").
/// [cancelText] - Teks tombol batal (default: "Cancel").
/// [icon] - Ikon yang ingin ditampilkan (opsional).
/// [iconColor] - Warna ikon (opsional).
/// 
/// Mengembalikan `true` jika user menekan tombol konfirmasi, `false` jika batal, dan `null` jika dialog ditutup tanpa aksi.
Future<bool?> showCustomConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmText = "Yes",
  String cancelText = "Cancel",
  IconData? icon,
  Color? iconColor,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => CustomConfirmDialog(
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      icon: icon,
      iconColor: iconColor,
    ),
  );
}