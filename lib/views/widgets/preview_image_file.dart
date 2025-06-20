import 'dart:io';

import 'package:flutter/material.dart';

/* * This file contains the PreviewImageFile widget which is used to preview image files.
 * It displays the image in a full-screen view with a transparent app bar.
 * The widget takes a File object as input and uses Image.file to display the image.
 */
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
