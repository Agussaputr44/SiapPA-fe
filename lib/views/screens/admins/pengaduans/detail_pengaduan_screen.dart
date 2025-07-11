import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:siappa/views/screens/admins/widgets/app_bar_widget.dart';
import 'package:siappa/views/widgets/loading_widget.dart';
import 'package:siappa/views/widgets/media_preview_widget.dart';
import '../../../../configs/api_config.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/pengaduans_provider.dart';

// Definisi untuk status pengaduan
enum PengaduanStatus {
  terkirim,
  diproses,
  selesai,
}

// Definisi untuk opsi dropdown korban
class DropdownOption {
  final String displayText;
  final String databaseValue;

  const DropdownOption({
    required this.displayText,
    required this.databaseValue,
  });
}

class PengaduanDetailScreen extends StatefulWidget {
  final dynamic pengaduan;

  const PengaduanDetailScreen({
    Key? key,
    required this.pengaduan,
  }) : super(key: key);

  @override
  State<PengaduanDetailScreen> createState() => _PengaduanDetailScreenState();
}

class _PengaduanDetailScreenState extends State<PengaduanDetailScreen> {
  late PengaduanStatus _selectedStatus;
  bool _isUpdating = false;

  // Opsi untuk jenis korban
  final List<DropdownOption> _korbanOptions = [
    const DropdownOption(
        displayText: 'Anak Laki-laki', databaseValue: 'anak_laki_laki'),
    const DropdownOption(
        displayText: 'Anak Perempuan', databaseValue: 'anak_perempuan'),
    const DropdownOption(
        displayText: 'Perempuan Dewasa', databaseValue: 'perempuan'),
  ];

  @override
  void initState() {
    super.initState();
    _selectedStatus = _getStatusFromString(widget.pengaduan.status);
  }

  // Helper untuk mengonversi string status ke Enum
  PengaduanStatus _getStatusFromString(String? statusString) {
    if (statusString == null) return PengaduanStatus.terkirim;
    switch (statusString.toLowerCase()) {
      case 'terkirim':
        return PengaduanStatus.terkirim;
      case 'diproses':
        return PengaduanStatus.diproses;
      case 'selesai':
        return PengaduanStatus.selesai;
      default:
        return PengaduanStatus.terkirim;
    }
  }

  // Helper untuk mengonversi Enum status ke string
  String _getStringFromStatus(PengaduanStatus status) {
    switch (status) {
      case PengaduanStatus.terkirim:
        return 'terkirim';
      case PengaduanStatus.diproses:
        return 'diproses';
      case PengaduanStatus.selesai:
        return 'selesai';
    }
  }

  // Helper function to beautify category names for display
  String beautifyCategory(String? kategori) {
    if (kategori == null) return 'Tidak Diketahui';
    switch (kategori.toLowerCase()) {
      case 'kekerasan_fisik':
        return 'Kekerasan Fisik';
      case 'kekerasan_psikis':
        return 'Kekerasan Psikis';
      case 'kekerasan_seksual':
        return 'Kekerasan Seksual';
      case 'kekerasan_ekonomi':
        return 'Kekerasan Ekonomi';
      case 'kekerasan_sosial':
        return 'Kekerasan Sosial';
      case 'perundungan':
        return 'Perundungan';
      default:
        return kategori.replaceAll('_', ' ').split(' ').map((e) {
          if (e.isEmpty) return '';
          return e[0].toUpperCase() + e.substring(1);
        }).join(' ');
    }
  }

  // Helper function to beautify korban for display
  String beautifyKorban(String? korban) {
    if (korban == null) return 'Tidak Diketahui';
    final option = _korbanOptions.firstWhere(
      (opt) => opt.databaseValue.toLowerCase() == korban.toLowerCase(),
      orElse: () => DropdownOption(displayText: korban, databaseValue: korban),
    );
    return option.displayText;
  }

  // Helper function to get a color based on category
  Color getCategoryColor(String? kategori) {
    if (kategori == null) return const Color(0xFF7986CB);
    switch (kategori.toLowerCase()) {
      case 'kekerasan_fisik':
        return const Color(0xFFE57373);
      case 'kekerasan_psikis':
        return const Color(0xFF9575CD);
      case 'kekerasan_seksual':
        return const Color(0xFFF06292);
      case 'kekerasan_ekonomi':
        return const Color(0xFF4FC3F7);
      case 'kekerasan_sosial':
        return const Color(0xFF81C784);
      case 'perundungan':
        return const Color(0xFFFFB300);
      default:
        return const Color(0xFF7986CB);
    }
  }

  // Helper function to get an icon based on category
  IconData getCategoryIcon(String? kategori) {
    if (kategori == null) return Icons.report_rounded;
    switch (kategori.toLowerCase()) {
      case 'kekerasan_fisik':
        return Icons.healing_rounded;
      case 'kekerasan_psikis':
        return Icons.psychology_rounded;
      case 'kekerasan_seksual':
        return Icons.shield_rounded;
      case 'kekerasan_ekonomi':
        return Icons.attach_money_rounded;
      case 'kekerasan_sosial':
        return Icons.groups_rounded;
      case 'perundungan':
        return Icons.mood_bad_rounded;
      default:
        return Icons.report_rounded;
    }
  }

  // Helper function to get a color based on status
  Color getStatusColor(PengaduanStatus status) {
    switch (status) {
      case PengaduanStatus.terkirim:
        return Colors.blue.shade600;
      case PengaduanStatus.diproses:
        return Colors.orange.shade600;
      case PengaduanStatus.selesai:
        return Colors.green.shade600;
    }
  }

  // Helper function to get a readable text for status
  String getStatusText(PengaduanStatus status) {
    switch (status) {
      case PengaduanStatus.terkirim:
        return 'Terkirim';
      case PengaduanStatus.diproses:
        return 'Diproses';
      case PengaduanStatus.selesai:
        return 'Selesai';
    }
  }

  // Helper to check if a path is an image URL
  bool _isImageUrl(String path) {
    final lowerCasePath = path.toLowerCase();
    return lowerCasePath.endsWith('.jpg') ||
        lowerCasePath.endsWith('.jpeg') ||
        lowerCasePath.endsWith('.png') ||
        lowerCasePath.endsWith('.gif');
  }

  // Update status method
  Future<void> _updateStatus() async {
    setState(() {
      _isUpdating = true;
    });

    try {
      final pengaduansProvider = context.read<PengaduansProvider>();
      await pengaduansProvider.updatePengaduanStatus(
        id: widget.pengaduan.id.toString(),
        status: _getStringFromStatus(_selectedStatus),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              pengaduansProvider.successMessage ?? 'Status pengaduan berhasil diperbarui!',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
        // Update the local status to reflect the change
        setState(() {
          widget.pengaduan.status = _getStringFromStatus(_selectedStatus);
        });
      }
    } catch (error) {
      if (mounted) {
        final pengaduansProvider = context.read<PengaduansProvider>();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              pengaduansProvider.errorMessage ?? 'Gagal memperbarui status: $error',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = getCategoryColor(widget.pengaduan.kategoriKekerasan);
    final categoryIcon = getCategoryIcon(widget.pengaduan.kategoriKekerasan);
    final beautifiedCategory = beautifyCategory(widget.pengaduan.kategoriKekerasan);

    return LoadingWidget(
      isLoading: _isUpdating,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBarWidget(
          title: 'Detail Pengaduan',
          subtitle: 'Informasi lengkap pengaduan',
          onBack: () => Navigator.of(context).pop(),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Header Card
              _buildHeaderCard(categoryColor, categoryIcon, beautifiedCategory),

              // Detail Information
              _buildDetailCard(),

              // Evidence Grid
              _buildEvidenceGrid(),

              // Status Update Section
              _buildStatusUpdateCard(),

              // Bottom spacing
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Builds the header card
  Widget _buildHeaderCard(Color categoryColor, IconData categoryIcon, String beautifiedCategory) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            categoryColor,
            categoryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: categoryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  categoryIcon,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      beautifiedCategory,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Korban: ${widget.pengaduan.namaKorban ?? 'Tidak diketahui'}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 16,
                color: Colors.white.withOpacity(0.9),
              ),
              const SizedBox(width: 8),
              Text(
                widget.pengaduan.createdAt != null
                    ? DateFormat('EEEE, dd MMMM yyyy - HH:mm').format(widget.pengaduan.createdAt)
                    : 'Tanggal tidak tersedia',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  getStatusText(_selectedStatus),
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Builds the detail card
  Widget _buildDetailCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informasi Detail',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailItem('Nama Korban', widget.pengaduan.namaKorban ?? 'Tidak diketahui', Icons.person_rounded),
          _buildDetailItem('Alamat', widget.pengaduan.alamat ?? 'Tidak diketahui', Icons.location_on_rounded),
          _buildDetailItem('Jenis Korban', beautifyKorban(widget.pengaduan.korban), Icons.group_rounded),
          _buildDetailItem('Isi Pengaduan', widget.pengaduan.aduan ?? 'Tidak ada isi pengaduan', Icons.description_rounded),
          _buildDetailItem('Harapan', widget.pengaduan.harapan ?? 'Tidak ada harapan', Icons.star_rounded),
        ],
      ),
    );
  }

  // Builds the evidence grid with tap-to-preview
  Widget _buildEvidenceGrid() {
    if (widget.pengaduan.evidencePaths == null || widget.pengaduan.evidencePaths.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bukti-bukti',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.4,
              minWidth: double.infinity,
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.5,
              ),
              itemCount: widget.pengaduan.evidencePaths.length,
              itemBuilder: (context, index) {
                final evidencePath = widget.pengaduan.evidencePaths[index] ?? '';
                return GestureDetector(
                  onTap: evidencePath.isNotEmpty
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MediaPreviewWidget(
                                url: '${ApiConfig.baseUrl}$evidencePath',
                              ),
                            ),
                          );
                        }
                      : null,
                  child: Container(
                    constraints: const BoxConstraints(
                      minWidth: 100,
                      minHeight: 100,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[200],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: evidencePath.isEmpty
                          ? const Center(
                              child: Icon(Icons.broken_image, color: Colors.grey),
                            )
                          : _isImageUrl(evidencePath)
                              ? Image.network(
                                  '${ApiConfig.baseUrl}$evidencePath',
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
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Builds the status update card
  Widget _buildStatusUpdateCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Update Status Pengaduan',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Status Saat Ini:',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<PengaduanStatus>(
                isExpanded: true,
                value: _selectedStatus,
                icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.grey[700]),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black87,
                ),
                onChanged: (PengaduanStatus? newValue) {
                  setState(() {
                    _selectedStatus = newValue!;
                  });
                },
                items: PengaduanStatus.values.map<DropdownMenuItem<PengaduanStatus>>(
                  (PengaduanStatus status) {
                    return DropdownMenuItem<PengaduanStatus>(
                      value: status,
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: getStatusColor(status),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(getStatusText(status)),
                        ],
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isUpdating ? null : _updateStatus,
              style: ElevatedButton.styleFrom(
                backgroundColor: getStatusColor(_selectedStatus),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _isUpdating
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Memperbarui Status...',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      'Perbarui Status',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // Builds a single detail item
  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.5,
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