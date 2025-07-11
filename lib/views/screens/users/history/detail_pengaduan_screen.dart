import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:siappa/configs/api_config.dart';
import 'package:siappa/models/pengaduans_model.dart';
import 'package:siappa/providers/pengaduans_provider.dart';
import 'package:siappa/utils/app_colors.dart';
import 'package:siappa/views/widgets/confirm_dialog_widget.dart';
import 'package:siappa/views/widgets/messages_widget.dart';

import 'update_pengaduan_screen.dart';

class DetailPengaduanScreen extends StatelessWidget {
  final PengaduansModel pengaduan;

  const DetailPengaduanScreen({Key? key, required this.pengaduan})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Detail Pengaduan',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black87,
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(),
            _buildDetailInformation(context),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    final categoryInfo = _getCategoryInfo(pengaduan.kategoriKekerasan);

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  avatar: Icon(
                    categoryInfo.icon,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  label: Text(
                    categoryInfo.text,
                    style: GoogleFonts.poppins(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  side: BorderSide.none,
                ),
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
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              pengaduan.namaKorban,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  DateFormat('d MMMM yyyy, HH:mm').format(pengaduan.createdAt),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailInformation(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informasi Detail',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Lokasi', pengaduan.alamat),
          const SizedBox(height: 12),
          _buildInfoRow('Jenis Korban', _formatText(pengaduan.korban)),
          const SizedBox(height: 12),
          _buildInfoRow('Nama Korban', pengaduan.namaKorban),
          const SizedBox(height: 12),
          _buildInfoRow(
              'Kategori Kekerasan',
              _getCategoryInfo(pengaduan.kategoriKekerasan).text),
          const SizedBox(height: 16),
          Text(
            'Deskripsi Aduan',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            pengaduan.aduan,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
          if (pengaduan.harapan.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Harapan Korban',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              pengaduan.harapan,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ],
          if (pengaduan.evidencePaths.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Bukti Pendukung',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            _buildEvidenceGrid(),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ),
        const Text(': '),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEvidenceGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.5,
      ),
      itemCount: pengaduan.evidencePaths.length,
      itemBuilder: (context, index) {
        final evidencePath = pengaduan.evidencePaths[index];
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[200],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _isImageUrl(evidencePath)
                ? Image.network(
                    ApiConfig.baseUrl + evidencePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.broken_image, color: Colors.grey),
                      );
                    },
                  )
                : const Center(
                    child: Icon(Icons.videocam, size: 30, color: Colors.grey),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(BuildContext context) {
  return Container(
    margin: const EdgeInsets.all(16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // Navigate to PengaduanUsersScreen with the existing pengaduan
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PengaduanUsersScreen(
                    existingPengaduan: PengaduansModel(
                      id: pengaduan.id,
                      namaKorban: pengaduan.namaKorban,
                      alamat: pengaduan.alamat,
                      aduan: pengaduan.aduan,
                      status: pengaduan.status,
                      harapan: pengaduan.harapan,
                      kategoriKekerasan: pengaduan.kategoriKekerasan,
                      korban: pengaduan.korban,
                      evidencePaths: pengaduan.evidencePaths,
                      createdAt: pengaduan.createdAt,
                    ),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.edit, size: 18),
            label: Text(
              'Edit',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary.withOpacity(0.1),
              foregroundColor: AppColors.primary,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => CustomConfirmDialog(
                  title: 'Konfirmasi Hapus',
                  message: 'Apakah Anda yakin ingin menghapus pengaduan ini?',
                  confirmText: 'Hapus',
                  cancelText: 'Batal',
                  icon: Icons.delete_forever,
                  iconColor: Colors.red,
                ),
              );

              if (confirm == true) {
                await context
                    .read<PengaduansProvider>()
                    .deleteArticle(pengaduan.id);

                final error = context.read<PengaduansProvider>().errorMessage;

                if (error != null) {
                  MessagesWidget.showError(context, error);
                } else {
                  MessagesWidget.showSuccess(
                      context, "Pengaduan berhasil dihapus.");
                  Navigator.of(context).pop(true);
                }
              }
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: const Color(0xFFFAE5ED),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
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
      ],
    ),
  );
}
  String _formatText(String text) {
    if (text.isEmpty) return text;
    return text
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.isEmpty
            ? word
            : word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  _CategoryInfo _getCategoryInfo(String categoryValue) {
    switch (categoryValue) {
      case 'kekerasan_fisik':
        return _CategoryInfo('Kekerasan Fisik', Icons.sports_kabaddi);
      case 'kekerasan_seksual':
        return _CategoryInfo(
            'Kekerasan Seksual', Icons.report_problem_outlined);
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

class _CategoryInfo {
  final String text;
  final IconData icon;
  _CategoryInfo(this.text, this.icon);
}
