import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ArticleCardWidget extends StatelessWidget {
  final String title;
  final String? subtitle; // optional, e.g., "1 Artikel"
  final String? date;     // optional, for created date
  final VoidCallback? onDetail;
  final Color bgCircleColor;
  final Color? bgCircleShadow; // optional shadow color for variation

  const ArticleCardWidget({
    Key? key,
    required this.title,
    this.subtitle,
    this.date,
    this.onDetail,
    this.bgCircleColor = const Color(0xFFFFB6D6),
    this.bgCircleShadow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final shadowColor = bgCircleShadow ?? bgCircleColor.withOpacity(0.22);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circle top-left
          Positioned(
            top: 0,
            left: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
              ),
              child: SizedBox(
                width: 80,
                height: 65,
                child: CustomPaint(
                  painter: _CardCirclePainter(
                    color: bgCircleColor,
                    shadow: shadowColor,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 2),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
                if (date != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    date!,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onDetail,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xFFFAE5ED),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: Text(
                      'Rincian',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFFD81B60),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for decorative circle pattern
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