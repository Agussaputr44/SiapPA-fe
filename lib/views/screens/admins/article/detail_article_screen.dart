import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siappa/views/screens/admins/widgets/app_bar_widget.dart';

class DetailArticleScreen extends StatelessWidget {
  const DetailArticleScreen({super.key, this.onEdit});

  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    final String title = args['title'] ?? 'Judul Default';
    final String imageUrl = args['imageUrl'] ?? '';
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
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 0),
              child: Stack(
                children: [
                  // Decorative Background
                  Positioned(
                    left: 0,
                    top: 0,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(18),
                      ),
                      child: SizedBox(
                        width: 90,
                        height: 70,
                        child: CustomPaint(
                          painter: _CardCirclePainter(
                            color: const Color(0xFFFFB6D6), // Pink
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
                            padding: const EdgeInsets.symmetric(horizontal: 18.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                imageUrl,
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  height: 180,
                                  color: Colors.grey[300],
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.broken_image, size: 48, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFFAE5ED),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onEdit,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color(0xFFFAE5ED),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
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
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}

// Decorative painter for the top-left background
class _CardCirclePainter extends CustomPainter {
  final Color color;
  final Color shadow;
  _CardCirclePainter({required this.color, required this.shadow});

  @override
  void paint(Canvas canvas, Size size) {
    // Main semi-transparent circle
    final paint = Paint()
      ..color = color.withOpacity(0.25)
      ..style = PaintingStyle.fill;
    canvas.drawArc(
      Rect.fromLTWH(-size.width * 0.3, -size.height * 0.25, size.width * 1.55, size.height * 1.5),
      0.5, 2.2, false, paint,
    );

    // Decorative arc
    final arcPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawArc(
      Rect.fromLTWH(-size.width * 0.25, -size.height * 0.15, size.width * 1.2, size.height * 1.2),
      1.25, 1.85, false, arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}