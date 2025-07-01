/// Widget pembungkus (wrapper) yang menampilkan efek loading di atas [child] menggunakan LogoEffect.
/// 
/// [isLoading] menentukan apakah loading ditampilkan (true) atau tidak (false).
/// [child] adalah widget yang ingin dibungkus oleh loading overlay.
/// 
/// Jika [isLoading] true, maka widget akan menampilkan overlay LogoEffect di atas [child].
///
/// Contoh penggunaan:
/// ```dart
/// LoadingWidget(
///   isLoading: isLoading,
///   child: Scaffold(...),
/// )
/// ```
import 'package:flutter/material.dart';
import 'logo_effect.dart'; // Pastikan path sudah benar!

class LoadingWidget extends StatelessWidget {
  /// Status loading; jika true, overlay loading akan muncul.
  final bool isLoading;

  /// Widget utama yang akan dibungkus (di bawah overlay loading).
  final Widget child;

  const LoadingWidget({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: LogoEffect(logoSize: 50, borderSize: 60),
          ),
      ],
    );
  }
}