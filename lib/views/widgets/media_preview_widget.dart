import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class MediaPreviewWidget extends StatefulWidget {
  final String? url;
  final File? file;

  const MediaPreviewWidget({
    Key? key,
    this.url,
    this.file,
  }) : super(key: key);

  @override
  State<MediaPreviewWidget> createState() => _MediaPreviewWidgetState();
}

class _MediaPreviewWidgetState extends State<MediaPreviewWidget> {
  VideoPlayerController? _controller;

  bool get _isVideo {
    final path = widget.file?.path ?? widget.url ?? "";
    return path.toLowerCase().endsWith('.mp4') ||
        path.toLowerCase().endsWith('.mov') ||
        path.toLowerCase().endsWith('.avi');
  }

  @override
  void initState() {
    super.initState();

    if (_isVideo) {
      if (widget.file != null) {
        _controller = VideoPlayerController.file(widget.file!)
          ..initialize().then((_) {
            setState(() {});
            _controller?.setLooping(true);
            _controller?.play();
          });
      } else if (widget.url != null) {
        _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url!))
          ..initialize().then((_) {
            setState(() {});
            _controller?.setLooping(true);
            _controller?.play();
          });
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          _isVideo ? 'Preview Video' : 'Preview Gambar',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
      body: Center(
        child: _isVideo
            ? (_controller != null && _controller!.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  )
                : const CircularProgressIndicator())
            : widget.file != null
                ? Image.file(widget.file!)
                : widget.url != null
                    ? Image.network(widget.url!)
                    : const Text(
                        "No media",
                        style: TextStyle(color: Colors.white),
                      ),
      ),
    );
  }
}
