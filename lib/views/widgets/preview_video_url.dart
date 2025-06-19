import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PreviewPage extends StatefulWidget {
  final String url;

  const PreviewPage({Key? key, required this.url}) : super(key: key);

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  late VideoPlayerController _videoController;
  bool _isVideo = false;
  
  @override
  void initState() {
    super.initState();
    _isVideo = widget.url.endsWith('.mp4');
    if (_isVideo) {
      _videoController = VideoPlayerController.network(widget.url)
        ..initialize().then((_) {
          setState(() {});
          _videoController.play();
        });
    }
  }

  @override
  void dispose() {
    if (_isVideo) {
      _videoController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: _isVideo
            ? (_videoController.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _videoController.value.aspectRatio,
                    child: VideoPlayer(_videoController),
                  )
                : const CircularProgressIndicator())
            : InteractiveViewer(
                child: Image.network(
                  widget.url,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, color: Colors.white),
                ),
              ),
      ),
    );
  }
}
