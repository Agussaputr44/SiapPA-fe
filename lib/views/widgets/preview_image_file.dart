import 'dart:io';

import 'package:flutter/material.dart';

class PreviewImageFile extends StatelessWidget {
  final File file;

  const PreviewImageFile({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("")),
      body: Center(
        child: Image.file(
          file,
          fit: BoxFit.contain,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}