import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'package:intl/intl.dart';                 // Import Intl untuk format tanggal
import 'package:provider/provider.dart';
import 'package:siappa/configs/api_config.dart';
import 'package:siappa/providers/auth_provider.dart';
import 'package:siappa/providers/pengaduans_provider.dart';
import 'package:siappa/views/screens/users/history/detail_pengaduan_screen.dart';
import 'package:siappa/views/widgets/tittle_custom_widget.dart';
import '../../../../models/pengaduans_model.dart';
import '../../../../utils/app_colors.dart'; 

class HistoryPengaduanScreen extends StatefulWidget {
  const HistoryPengaduanScreen({Key? key}) : super(key: key);

  @override
  State<HistoryPengaduanScreen> createState() => _HistoryPengaduanScreenState();
}

class _CategoryInfo {
  final String text;
  final IconData icon;
  _CategoryInfo(this.text, this.icon);
}

class _HistoryPengaduanScreenState extends State<HistoryPengaduanScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      Provider.of<PengaduansProvider>(context, listen: false)
          .loadMyPengaduans(authProvider);
    });
  }

  _CategoryInfo _getCategoryInfo(String categoryValue) {
    switch (categoryValue) {
      case 'kekerasan_fisik':
        return _CategoryInfo('Kekerasan Fisik', Icons.sports_kabaddi);
      case 'kekerasan_seksual':
        return _CategoryInfo('Kekerasan Seksual', Icons.report_problem_outlined);
      case 'kekerasan_psikis':
        return _CategoryInfo('Kekerasan Psikis', Icons.psychology_alt);
      case 'kekerasan_ekonomi':
        return _CategoryInfo('Kekerasan Ekonomi', Icons.trending_down);
      case 'kekerasan_sosial':
        return _CategoryInfo('Kekerasan Sosial', Icons.groups);
      default:
        return _CategoryInfo('Lainnya', Icons.help_outline);
    }
  }

  bool _isImageUrl(String url) {
    final lowerCaseUrl = url.toLowerCase();
    return lowerCaseUrl.endsWith('.jpg') ||
        lowerCaseUrl.endsWith('.jpeg') ||
        lowerCaseUrl.endsWith('.png') ||
        lowerCaseUrl.endsWith('.gif');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TitleCustom(title: "Riwayat Pengaduan"),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final authProvider = Provider.of<AuthProvider>(context, listen: false);
              Provider.of<PengaduansProvider>(context, listen: false)
                  .loadMyPengaduans(authProvider);
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[100], 
      body: Consumer<PengaduansProvider>(
        builder: (context, pengaduanProvider, child) {
          if (pengaduanProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (pengaduanProvider.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  pengaduanProvider.errorMessage!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(color: Colors.red, fontSize: 16),
                ),
              ),
            );
          }

          if (pengaduanProvider.pengaduans.isEmpty) {
            return Center(
              child: Text(
                "Anda belum memiliki riwayat pengaduan.",
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: pengaduanProvider.pengaduans.length,
            itemBuilder: (context, index) {
              final pengaduan = pengaduanProvider.pengaduans[index];
              return _buildHistoryCard(context, pengaduan);
            },
          );
        },
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, PengaduansModel pengaduan) {
    final categoryInfo = _getCategoryInfo(pengaduan.kategoriKekerasan);
    final hasMedia = pengaduan.evidencePaths.isNotEmpty;
    final firstMediaUrl = hasMedia ? pengaduan.evidencePaths.first : '';
    print("ini media $firstMediaUrl");

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Navigasi ke halaman detail saat kartu di-klik (SUDAH DIAKTIFKAN)
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => DetailPengaduanScreen(pengaduan: pengaduan),
          //   ),
          // );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasMedia)
              Container(
                height: 180,
                width: double.infinity,
                color: Colors.grey[200], 
                child: _isImageUrl(firstMediaUrl)
                    ? Image.network(
                      ApiConfig.baseUrl+
                        firstMediaUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image, size: 40, color: Colors.grey);
                        },
                      )
                    : const Icon(Icons.videocam, size: 60, color: Colors.grey), 
              ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Baris untuk Kategori dan Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Chip untuk Kategori Kekerasan
                      Chip(
                        avatar: Icon(categoryInfo.icon, size: 18, color: AppColors.primary),
                        label: Text(
                          categoryInfo.text,
                          style: GoogleFonts.poppins(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        side: BorderSide.none,
                      ),
                      // Chip untuk Status
                      Chip(
                        label: Text(
                          pengaduan.status.toUpperCase(),
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: _getStatusColor(pengaduan.status),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Nama Korban
                  Text(
                    pengaduan.namaKorban,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // Tanggal Pengaduan
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 6),
                      Text(
                        // Format tanggal menjadi "10 Juli 2025"
                        DateFormat('d MMMM yyyy').format(pengaduan.createdAt),
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper untuk menentukan warna chip berdasarkan status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'diproses':
        return Colors.orange.shade400;
      case 'selesai':
        return Colors.green.shade400;
      case 'terkirim':
      default:
        return Colors.green.shade400;
    }
  }
}