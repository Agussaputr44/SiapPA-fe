import 'dart:io';

/* * This file contains the PreviewScreen widget which is used to preview media files
 * such as images and videos. It uses the VideoPlayer package for video playback.
 * The widget checks the file type and displays the appropriate preview.
 */
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PreviewScreen extends StatelessWidget {
  final File file;
  const PreviewScreen({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    final isImage = ['.jpg', '.jpeg', '.png'].any(
      (ext) => file.path.toLowerCase().endsWith(ext),
    );
    final isVideo = file.path.toLowerCase().endsWith('.mp4');

    return Scaffold(
      appBar: AppBar(title: const Text('Preview')),
      body: Center(
        child: isImage
            ? Image.file(file)
            : isVideo
                ? VideoPlayerPreview(file: file)
                : const Text('Format tidak dikenali'),
      ),
    );
  }
}

class VideoPlayerPreview extends StatefulWidget {
  final File file;
  const VideoPlayerPreview({super.key, required this.file});

  @override
  State<VideoPlayerPreview> createState() => _VideoPlayerPreviewState();
}

class _VideoPlayerPreviewState extends State<VideoPlayerPreview> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.file)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : const CircularProgressIndicator();
  }
}
