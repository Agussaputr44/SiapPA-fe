import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:siappa/helpers/dialog_helper.dart';
import 'package:siappa/providers/articles_provider.dart';
import 'package:siappa/utils/app_colors.dart';
import '../../../../models/pengaduans_model.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/pengaduans_provider.dart';
import '../../../../providers/users_provider.dart';
import '../../../widgets/loading_widget.dart';
import 'header_widget.dart';
import 'card_widget.dart';
import '../widgets/report_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final usersProvider = Provider.of<UsersProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final articlesProvider = Provider.of<ArticlesProvider>(context, listen: false);
      final pengaduansProvider = Provider.of<PengaduansProvider>(context, listen: false);

      usersProvider.loadUserDetails(authProvider);
      usersProvider.loadAllUsers(authProvider);
      articlesProvider.loadAllArticles(authProvider);
      pengaduansProvider.loadAllPengaduans(authProvider);
    });
  }

  // Fungsi bantu untuk hitung jumlah berdasarkan kategori
  int countByCategory(List<PengaduansModel> list, String kategori) {
    return list.where((item) => item.kategoriKekerasan == kategori).length;
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<UsersProvider>().isLoading;
    final pengaduans = context.watch<PengaduansProvider>().pengaduans;
    final articles = context.watch<ArticlesProvider>().articles;
    final users = context.watch<UsersProvider>().allUsers;

    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await showCustomConfirmDialog(
          context: context,
          title: "Konfirmasi",
          message: "Apakah anda yakin untuk keluar?",
          confirmText: "Ya",
          cancelText: "Batal",
          icon: Icons.exit_to_app,
          iconColor: Colors.red,
        );
        return shouldExit ?? false;
      },
      child: LoadingWidget(
        isLoading: isLoading,
        child: Scaffold(
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
                            count: '${pengaduans.length} Laporan',
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
                            count: '${articles.length} Artikel',
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
                      count: '${users.length} Pengguna',
                      iconAsset: 'assets/icons/artikel.png',
                      onTap: () => Navigator.of(context).pushNamed('/users'),
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
                          subtitle: '${countByCategory(pengaduans, 'kekerasan_fisik')} Laporan',
                          additionalCount: countByCategory(pengaduans, 'kekerasan_fisik'),
                          color: const Color(0xFFE57373),
                          onDetail: () {
                            Navigator.pushNamed(
                              context,
                              '/users/pengaduan/by_category',
                              arguments: 'kekerasan_fisik',
                            );
                          },
                        ),
                        ReportCard(
                          imageAsset: 'assets/icons/ic_psikis.png',
                          title: 'Kekerasan Psikis',
                          subtitle: '${countByCategory(pengaduans, 'kekerasan_psikis')} Laporan',
                          additionalCount: countByCategory(pengaduans, 'kekerasan_psikis'),
                          color: const Color(0xFF7986CB),
                          onDetail: () {
                            Navigator.pushNamed(
                              context,
                              '/users/pengaduan/by_category',
                              arguments: 'kekerasan_psikis',
                            );
                          },
                        ),
                        ReportCard(
                          imageAsset: 'assets/icons/ic_seksual.png',
                          title: 'Kekerasan Seksual',
                          subtitle: '${countByCategory(pengaduans, 'kekerasan_seksual')} Laporan',
                          additionalCount: countByCategory(pengaduans, 'kekerasan_seksual'),
                          color: const Color(0xFFD81B60),
                          onDetail: () {
                            Navigator.pushNamed(
                              context,
                              '/users/pengaduan/by_category',
                              arguments: 'kekerasan_seksual',
                            );
                          },
                        ),
                        ReportCard(
                          imageAsset: 'assets/icons/ic_ekonomi.png',
                          title: 'Kekerasan Ekonomi',
                          subtitle: '${countByCategory(pengaduans, 'kekerasan_ekonomi')} Laporan',
                          additionalCount: countByCategory(pengaduans, 'kekerasan_ekonomi'),
                          color: const Color.fromARGB(255, 40, 216, 27),
                          onDetail: () {
                            Navigator.pushNamed(
                              context,
                              '/users/pengaduan/by_category',
                              arguments: 'kekerasan_ekonomi',
                            );
                          },
                        ),
                        ReportCard(
                          imageAsset: 'assets/icons/ic_sosial.png',
                          title: 'Kekerasan Sosial',
                          subtitle: '${countByCategory(pengaduans, 'kekerasan_sosial')} Laporan',
                          additionalCount: countByCategory(pengaduans, 'kekerasan_sosial'),
                          color: const Color.fromARGB(255, 27, 71, 216),
                          onDetail: () {
                            Navigator.pushNamed(
                              context,
                              '/users/pengaduan/by_category',
                              arguments: 'kekerasan_sosial',
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}