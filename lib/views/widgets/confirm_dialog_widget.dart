/// Widget untuk dialog konfirmasi custom yang reusable di aplikasi.
///
/// Menampilkan judul, pesan, ikon (opsional), serta dua tombol aksi (konfirmasi & batal).
/// Dapat digunakan untuk berbagai kebutuhan seperti konfirmasi logout, hapus data, keluar aplikasi, dsb.
///
/// Contoh penggunaan (melalui showDialog atau helper):
/// ```dart
/// final result = await showDialog<bool>(
///   context: context,
///   builder: (context) => CustomConfirmDialog(
///     title: "Konfirmasi",
///     message: "Apakah Anda yakin ingin keluar?",
///     confirmText: "Keluar",
///     cancelText: "Batal",
///     icon: Icons.exit_to_app,
///     iconColor: Colors.red,
///   ),
/// );
/// if (result == true) { ... }
/// ```
import 'package:flutter/material.dart';

class CustomConfirmDialog extends StatelessWidget {
  /// Judul dialog.
  final String title;

  /// Pesan yang ingin ditampilkan pada dialog.
  final String message;

  /// Teks pada tombol konfirmasi (default: "Yes").
  final String confirmText;

  /// Teks pada tombol batal (default: "Cancel").
  final String cancelText;

  /// Callback saat tombol konfirmasi ditekan (opsional).
  /// Jika null, otomatis akan menutup dialog dengan return true.
  final VoidCallback? onConfirm;

  /// Callback saat tombol batal ditekan (opsional).
  /// Jika null, otomatis akan menutup dialog dengan return false.
  final VoidCallback? onCancel;

  /// Ikon yang ingin ditampilkan (opsional).
  final IconData? icon;

  /// Warna ikon (opsional).
  final Color? iconColor;

  const CustomConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = "Yes",
    this.cancelText = "Cancel",
    this.onConfirm,
    this.onCancel,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          if (icon != null)
            Icon(icon, color: iconColor ?? Colors.pink, size: 28),
          if (icon != null) const SizedBox(width: 8),
          Expanded(
              child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          )),
        ],
      ),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: onCancel ?? () => Navigator.of(context).pop(false),
          child: Text(cancelText),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: onConfirm ?? () => Navigator.of(context).pop(true),
          child: Text(confirmText),
        ),
      ],
    );
  }
}