import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class MediaPreviewWidget extends StatefulWidget {
  final String url;
  const MediaPreviewWidget({Key? key, required this.url}) : super(key: key);

  @override
  State<MediaPreviewWidget> createState() => _MediaPreviewWidgetState();
}

class _MediaPreviewWidgetState extends State<MediaPreviewWidget> {
  VideoPlayerController? _controller;
  bool get _isVideo =>
      widget.url.toLowerCase().endsWith('.mp4') ||
      widget.url.toLowerCase().endsWith('.mov') ||
      widget.url.toLowerCase().endsWith('.avi');

  @override
  void initState() {
    super.initState();
    if (_isVideo) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
        ..initialize().then((_) {
          setState(() {});
          _controller?.setLooping(true);
          _controller?.play();
        });
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
            : Image.network(widget.url),
      ),
    );
  }
}
