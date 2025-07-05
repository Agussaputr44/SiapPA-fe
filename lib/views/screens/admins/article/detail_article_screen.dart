import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:siappa/configs/api_config.dart';
import 'package:siappa/providers/articles_provider.dart';
import 'package:siappa/views/screens/admins/widgets/app_bar_widget.dart';
import 'package:siappa/views/widgets/media_preview_widget.dart';
import 'package:siappa/views/widgets/messages_widget.dart';
import 'package:video_player/video_player.dart';

import '../../../widgets/confirm_dialog_widget.dart';

class DetailArticleScreen extends StatefulWidget {
  const DetailArticleScreen({super.key, this.onEdit});
  final VoidCallback? onEdit;

  @override
  State<DetailArticleScreen> createState() => _DetailArticleScreenState();
}

class _DetailArticleScreenState extends State<DetailArticleScreen> {
  VideoPlayerController? _videoController;
  bool _isVideo = false;
  late String imageUrl;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    const url = ApiConfig.baseUrl;
    imageUrl = '$url${args['imageUrl'] ?? ''}';
    final fileExtension = imageUrl.split('.').last.toLowerCase();

    _isVideo = ['mp4', 'mov', 'avi'].contains(fileExtension);

    if (_isVideo) {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(imageUrl))
        ..initialize().then((_) {
          setState(() {});
          _videoController!.setLooping(true);
          _videoController!.play();
        });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final String title = args['title'] ?? 'Judul Default';
    final String content = args['content'] ?? 'Konten default';

    return Scaffold(
      appBar: const AppBarWidget(
        title: 'Rincian Artikel',
        subtitle: 'Sistem Informasi Aduan dan Perlindungan Perempuan dan Anak',
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 0,
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.only(topLeft: Radius.circular(18)),
                      child: SizedBox(
                        width: 90,
                        height: 70,
                        child: CustomPaint(
                          painter: _CardCirclePainter(
                            color: const Color(0xFFFFB6D6),
                            shadow: const Color(0xFFFFB6D6),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 18, 0, 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        MediaPreviewWidget(url: imageUrl),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: _isVideo
                                    ? (_videoController != null &&
                                            _videoController!
                                                .value.isInitialized
                                        ? Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              AspectRatio(
                                                aspectRatio: _videoController!
                                                    .value.aspectRatio,
                                                child: VideoPlayer(
                                                    _videoController!),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    if (_videoController!
                                                        .value.isPlaying) {
                                                      _videoController!.pause();
                                                    } else {
                                                      _videoController!.play();
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.black45,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(12),
                                                  child: Icon(
                                                    _videoController!
                                                            .value.isPlaying
                                                        ? Icons.pause
                                                        : Icons.play_arrow,
                                                    color: Colors.white,
                                                    size: 40,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : const SizedBox(
                                            height: 180,
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator()),
                                          ))
                                    : Image.network(
                                        imageUrl,
                                        height: 180,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                          height: 180,
                                          color: Colors.grey[300],
                                          alignment: Alignment.center,
                                          child: const Icon(Icons.broken_image,
                                              size: 48, color: Colors.grey),
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFFAE5ED),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 14),
                              child: Text(
                                content,
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: const Color(0xFFD81B60),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tombol Edit
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      onPressed: widget.onEdit,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color(0xFFFAE5ED),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      child: Text(
                        'Edit',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFFD81B60),
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                // Tombol Hapus
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => CustomConfirmDialog(
                            title: 'Konfirmasi Hapus',
                            message:
                                'Apakah Anda yakin ingin menghapus artikel ini?',
                            confirmText: 'Hapus',
                            cancelText: 'Batal',
                            icon: Icons.delete_forever,
                            iconColor: Colors.red,
                          ),
                        );

                        if (confirm == true) {
                          final int? articleId = args['id'];
                          if (articleId == null) {
                            MessagesWidget.showError(
                                context, "ID artikel tidak ditemukan.");
                            return;
                          }

                          await context
                              .read<ArticlesProvider>()
                              .deleteArticle(articleId);

                          final error =
                              context.read<ArticlesProvider>().errorMessage;
                          if (error != null) {
                            MessagesWidget.showError(context, error);
                          } else {
                            MessagesWidget.showSuccess(
                                context, "Artikel berhasil dihapus.");
                            Navigator.of(context).pop(true);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color(0xFFFAE5ED),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      child: Text(
                        'Hapus',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFFD81B60),
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}

class _CardCirclePainter extends CustomPainter {
  final Color color;
  final Color shadow;
  _CardCirclePainter({required this.color, required this.shadow});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.25)
      ..style = PaintingStyle.fill;
    canvas.drawArc(
      Rect.fromLTWH(-size.width * 0.3, -size.height * 0.25, size.width * 1.55,
          size.height * 1.5),
      0.5,
      2.2,
      false,
      paint,
    );

    final arcPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawArc(
      Rect.fromLTWH(-size.width * 0.25, -size.height * 0.15, size.width * 1.2,
          size.height * 1.2),
      1.25,
      1.85,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
