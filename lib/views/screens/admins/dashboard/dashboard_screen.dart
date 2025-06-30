import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siappa/utils/app_colors.dart';
import 'header_widget.dart';
import 'card_widget.dart';
import '../widgets/report_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const HeaderWidget(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CardWidget(
                        title: 'Laporan',
                        count: '5 Kriteria',
                        additionalCount: 2,
                        iconAsset: 'assets/icons/laporan.png',
                        onTap: () => Navigator.of(context).pushNamed('/laporan'),
                        background: CardBgType.circleTopLeft,
                        detailColor: const Color(0xFFF48FB1),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CardWidget(
                        title: 'Artikel',
                        count: '10 Artikel',
                        additionalCount: 7,
                        iconAsset: 'assets/icons/artikel.png',
                        onTap: () => Navigator.of(context).pushNamed('/artikel'),
                        background: CardBgType.circleTopLeft,
                        detailColor: const Color(0xFFF48FB1),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CardWidget(
                  title: 'Pengguna',
                  count: '10 Akun',
                  additionalCount: 7,
                  iconAsset: 'assets/icons/artikel.png',
                  onTap: () {},
                  isWide: true,
                  background: CardBgType.circleLeft,
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
          const SizedBox(height: 10),
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
                child: Column(
                  children: [
                    ReportCard(
                      imageAsset: 'assets/icons/ic_fisik.png',
                      title: 'Kekerasan Fisik',
                      subtitle: '5 Laporan',
                      additionalCount: 5,
                      color: const Color(0xFFE57373),
                      onDetail: () {},
                    ),
                    ReportCard(
                      imageAsset: 'assets/icons/ic_fisik.png',
                      title: 'kekerasan Psikis',
                      subtitle: '5 Laporan',
                      additionalCount: 5,
                      color: const Color(0xFF7986CB),
                      onDetail: () {},
                    ),
                    ReportCard(
                      imageAsset: 'assets/icons/ic_fisik.png',
                      title: 'Kekerasan Seksual',
                      subtitle: '5 Laporan',
                      additionalCount: 5,
                      color: const Color(0xFFD81B60),
                      onDetail: () {},
                    ),
                    ReportCard(
                      imageAsset: 'assets/icons/ic_fisik.png',
                      title: 'Kekerasan Seksual',
                      subtitle: '5 Laporan',
                      additionalCount: 5,
                      color: const Color(0xFFD81B60),
                      onDetail: () {},
                    ),
                    ReportCard(
                      imageAsset: 'assets/icons/ic_fisik.png',
                      title: 'Kekerasan Seksual',
                      subtitle: '5 Laporan',
                      additionalCount: 5,
                      color: const Color(0xFFD81B60),
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