import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:siappa/configs/api_config.dart';
import 'package:siappa/models/pengaduans_model.dart';
import 'package:siappa/views/widgets/loading_widget.dart';
import '../../../../providers/pengaduans_provider.dart';
import '../../../../utils/app_colors.dart';
import '../../../widgets/tittle_custom_widget.dart';

class PengaduanByCategoryScreen extends StatelessWidget {
  const PengaduanByCategoryScreen({Key? key}) : super(key: key);

  // Helper to beautify category names
  String _beautifyCategory(String category) {
    switch (category.toLowerCase()) {
      case 'kekerasan_fisik':
        return 'Kekerasan Fisik';
      case 'kekerasan_seksual':
        return 'Kekerasan Seksual';
      case 'kekerasan_psikis':
        return 'Kekerasan Psikis';
      case 'kekerasan_ekonomi':
        return 'Kekerasan Ekonomi';
      case 'kekerasan_sosial':
        return 'Kekerasan Sosial';
      default:
        return category.replaceAll('_', ' ').split(' ').map((e) => e[0].toUpperCase() + e.substring(1)).join(' ');
    }
  }

  // Helper to get category icon
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'kekerasan_fisik':
        return Icons.healing_rounded;
      case 'kekerasan_seksual':
        return Icons.shield_rounded;
      case 'kekerasan_psikis':
        return Icons.psychology_rounded;
      case 'kekerasan_ekonomi':
        return Icons.attach_money_rounded;
      case 'kekerasan_sosial':
        return Icons.groups_rounded;
      default:
        return Icons.report_rounded;
    }
  }

  // Helper to get status color
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'terkirim':
        return Colors.blue.shade600;
      case 'diproses':
        return Colors.orange.shade600;
      case 'selesai':
        return Colors.green.shade600;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String category = ModalRoute.of(context)!.settings.arguments as String;

    return LoadingWidget(
      isLoading: context.watch<PengaduansProvider>().isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: TitleCustom(title: 'Laporan ${_beautifyCategory(category)}'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Consumer<PengaduansProvider>(
          builder: (context, pengaduansProvider, child) {
            if (pengaduansProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final filteredPengaduans = pengaduansProvider.pengaduans
                .where((p) => p.kategoriKekerasan == category)
                .toList();

            if (filteredPengaduans.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Belum ada laporan untuk kategori ${_beautifyCategory(category)}',
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: filteredPengaduans.length,
              itemBuilder: (context, index) {
                final pengaduan = filteredPengaduans[index];
                return _buildPengaduanCard(context, pengaduan);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildPengaduanCard(BuildContext context, PengaduansModel pengaduan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/users/pengaduan/detail',
            arguments: pengaduan,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 80,
                  height: 80,
                  color: AppColors.primary.withOpacity(0.1),
                  child: pengaduan.evidencePaths != null && pengaduan.evidencePaths!.isNotEmpty
                      ? Image.network(
                          ApiConfig.baseUrl + pengaduan.evidencePaths!.first,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              _getCategoryIcon(pengaduan.kategoriKekerasan ?? ''),
                              size: 30,
                              color: AppColors.primary,
                            );
                          },
                        )
                      : Icon(
                          _getCategoryIcon(pengaduan.kategoriKekerasan ?? ''),
                          size: 30,
                          color: AppColors.primary,
                        ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pengaduan.namaKorban ?? 'Korban Tidak Diketahui',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      pengaduan.aduan ?? 'Deskripsi tidak tersedia',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(pengaduan.status),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            pengaduan.status[0].toUpperCase() + pengaduan.status.substring(1),
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 5),
                        Text(
                          _formatDate(pengaduan.createdAt),
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: Colors.grey[500],
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
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Tanggal tidak tersedia';
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inDays == 0) {
      return 'Hari ini';
    } else if (difference.inDays == 1) {
      return '1 hari yang lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return weeks == 1 ? '1 minggu yang lalu' : '$weeks minggu yang lalu';
    } else {
      final months = (difference.inDays / 30).floor();
      return months == 1 ? '1 bulan yang lalu' : '$months bulan yang lalu';
    }
  }
}