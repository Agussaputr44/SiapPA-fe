import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siappa/utils/app_colors.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const _HeaderWidget(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _CardWidget(
                        title: 'Laporan',
                        count: '5 Kriteria',
                        additionalCount: 2,
                        iconAsset: 'assets/icons/laporan.png',
                        onTap: () {},
                        background: _CardBgType.circleTopLeft,
                        detailColor: const Color(0xFFF48FB1),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _CardWidget(
                        title: 'Artikel',
                        count: '10 Artikel',
                        additionalCount: 7,
                        iconAsset: 'assets/icons/artikel.png',
                        onTap: () {},
                        background: _CardBgType.circleTopLeft,
                        detailColor: const Color(0xFFF48FB1),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _CardWidget(
                  title: 'Pengguna',
                  count: '10 Akun',
                  additionalCount: 7,
                  iconAsset: 'assets/icons/artikel.png',
                  onTap: () {},
                  isWide: true,
                  background: _CardBgType.circleLeft,
                  detailColor: const Color(0xFFF48FB1),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            indent: 16,
            endIndent: 16,
            color: const Color(0xFFF48FB1),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Laporan Kekerasan",
                textAlign: TextAlign.start,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
              child: SingleChildScrollView(
                  child: Column(children: [
                    _ReportCard(
                      imageAsset: 'assets/icons/ic_fisik.png',
                      title: 'Kekerasan Fisik',
                      subtitle: '5 Laporan',
                      additionalCount: 5,
                      color: Color(0xFFE57373),
                      onDetail: () {},
                    ),
                    _ReportCard(
                      imageAsset: 'assets/icons/ic_fisik.png',
                      title: 'kekerasan Psikis',
                      subtitle: '5 Laporan',
                      additionalCount: 5,
                      color: Color(0xFF7986CB),
                      onDetail: () {},
                    ),
                    _ReportCard(
                      imageAsset: 'assets/icons/ic_fisik.png',
                      title: 'Kekerasan Seksual',
                      subtitle: '5 Laporan',
                      additionalCount: 5,
                      color: Color(0xFFD81B60),
                      onDetail: () {},
                    ),
                    _ReportCard(
                      imageAsset: 'assets/icons/ic_fisik.png',
                      title: 'Kekerasan Seksual',
                      subtitle: '5 Laporan',
                      additionalCount: 5,
                      color: Color(0xFFD81B60),
                      onDetail: () {},
                    ),
                    _ReportCard(
                      imageAsset: 'assets/icons/ic_fisik.png',
                      title: 'Kekerasan Seksual',
                      subtitle: '5 Laporan',
                      additionalCount: 5,
                      color: Color(0xFFD81B60),
                      onDetail: () {},
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50, right: 20.0, left: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    children: [
                      const TextSpan(text: "Hello "),
                      TextSpan(
                        text: "Mysyryf",
                        style: GoogleFonts.poppins(color: Colors.pink[400]),
                      ),
                    ],
                  ),
                ),
                Text(
                  "Kepedulian Yang utama",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 33,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[200],
                radius: 28,
                backgroundImage: AssetImage('assets/images/logo.png'),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

enum _CardBgType { circleTopLeft, circleLeft }

class _CardWidget extends StatelessWidget {
  final String title;
  final String count;
  final int additionalCount;
  final String iconAsset;
  final VoidCallback onTap;
  final bool isWide;
  final _CardBgType background;
  final Color detailColor;

  const _CardWidget({
    Key? key,
    required this.title,
    required this.count,
    required this.additionalCount,
    required this.iconAsset,
    required this.onTap,
    this.isWide = false,
    required this.background,
    required this.detailColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isWide ? double.infinity : null,
      margin: EdgeInsets.only(bottom: isWide ? 0 : 0),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        children: [
          // Decorative background shape
          if (background == _CardBgType.circleTopLeft)
            Positioned(
              top: -36,
              left: -36,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xFFB3E5FC).withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          if (background == _CardBgType.circleLeft)
            Positioned(
              top: 20,
              left: -40,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFB3E5FC).withOpacity(0.7),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    bottomLeft: Radius.circular(40),
                  ),
                ),
              ),
            ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 18.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon in a circle
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.08),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      iconAsset,
                      width: 35,
                      height: 35,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // Card Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        count,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: detailColor, width: 1),
                        ),
                        child: Text(
                          '+$additionalCount',
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: detailColor),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: isWide ? 120 : double.infinity,
                          child: ElevatedButton(
                            onPressed: onTap,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: detailColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              elevation: 0,
                            ),
                            child: Text(
                              'Detail',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
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

class _ReportCard extends StatelessWidget {
  final String imageAsset;
  final String title;
  final String subtitle;
  final int additionalCount;
  final Color color;
  final VoidCallback onDetail;
  final bool isTitleUppercase;

  const _ReportCard({
    Key? key,
    required this.imageAsset,
    required this.title,
    required this.subtitle,
    required this.additionalCount,
    required this.color,
    required this.onDetail,
    this.isTitleUppercase = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: color.withOpacity(0.28), // Soft colored border
          width: 1.3,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        child: Column(
          children: [
            Row(
              children: [
                // Leading image and color bg
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // background shape
                    Positioned(
                      left: 0,
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color.withOpacity(0.9),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          imageAsset,
                          fit: BoxFit.cover,
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14),
                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isTitleUppercase ? title : _capitalizeFirst(title),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                // +5 badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: color.withOpacity(0.25)),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.08),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    '+$additionalCount',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onDetail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color.withOpacity(0.18),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                child: Text(
                  'Rincian',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _capitalizeFirst(String text) =>
      text.isNotEmpty ? text[0].toUpperCase() + text.substring(1) : '';
}