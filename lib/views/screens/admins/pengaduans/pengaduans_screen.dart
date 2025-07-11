import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siappa/views/screens/admins/widgets/app_bar_widget.dart';
import 'package:siappa/views/widgets/loading_widget.dart';
import 'package:intl/intl.dart';
import '../../../../configs/api_config.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/pengaduans_provider.dart';
import 'detail_pengaduan_screen.dart';

// Definisi untuk status pengaduan
enum PengaduanStatus {
  terkirim,
  diproses,
  selesai,
}

class PengaduansScreen extends StatefulWidget {
  const PengaduansScreen({Key? key}) : super(key: key);

  @override
  State<PengaduansScreen> createState() => _PengaduansScreenState();
}

class _PengaduansScreenState extends State<PengaduansScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final authProvider = context.read<AuthProvider>();
      context.read<PengaduansProvider>().loadAllPengaduans(authProvider);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

  // Helper to convert string status to Enum
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

  // Navigate to detail screen
  void _navigateToDetail(dynamic pengaduan) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PengaduanDetailScreen(pengaduan: pengaduan),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pengaduansProvider = context.watch<PengaduansProvider>();
    final pengaduans = pengaduansProvider.pengaduans ?? [];
    final isLoading = pengaduansProvider.isLoading;

    // Filter based on search query
    final filteredPengaduans = pengaduans.where((pengaduan) {
      if (_searchQuery.isEmpty) return true;
      return (pengaduan.kategoriKekerasan
                  ?.toLowerCase()
                  ?.contains(_searchQuery.toLowerCase()) ??
              false) ||
          (pengaduan.namaKorban
                  ?.toLowerCase()
                  ?.contains(_searchQuery.toLowerCase()) ??
              false) ||
          (pengaduan.aduan
                  ?.toLowerCase()
                  ?.contains(_searchQuery.toLowerCase()) ??
              false);
    }).toList();

    return LoadingWidget(
      isLoading: isLoading,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBarWidget(
          title: 'Laporan Pengaduan',
          subtitle:
              'Sistem Informasi Aduan dan Perlindungan Perempuan dan Anak',
          onBack: () => Navigator.of(context).pop(),
        ),
        body: pengaduansProvider.errorMessage != null
            ? _buildErrorState(pengaduansProvider.errorMessage!)
            : Column(
                children: [
                  // Header with statistics
                  _buildHeaderStats(pengaduans.length),

                  // Search Bar
                  _buildSearchBar(),

                  // Content
                  Expanded(
                    child: filteredPengaduans.isEmpty
                        ? _buildEmptyState()
                        : _buildPengaduanList(filteredPengaduans),
                  ),
                ],
              ),
      ),
    );
  }

  // Builds the header section displaying total reports
  Widget _buildHeaderStats(int totalCount) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(241, 140, 176, 1),
            Color.fromRGBO(248, 187, 208, 1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(
              Icons.assessment_rounded,
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
                  'Total Laporan',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$totalCount',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Pengaduan terdaftar',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Builds the search bar widget
  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Cari berdasarkan kategori, nama, atau isi pengaduan...',
          hintStyle: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[600],
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Colors.grey[600],
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        style: GoogleFonts.poppins(fontSize: 14),
      ),
    );
  }

  // Builds the list of pengaduan cards
  Widget _buildPengaduanList(List pengaduans) {
    return RefreshIndicator(
      onRefresh: () async {
        final authProvider = context.read<AuthProvider>();
        await context
            .read<PengaduansProvider>()
            .loadAllPengaduans(authProvider);
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: pengaduans.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final pengaduan = pengaduans[index];
          if (pengaduan == null) return const SizedBox.shrink();
          return _buildPengaduanCard(pengaduan);
        },
      ),
    );
  }

  // Builds a single pengaduan card
  Widget _buildPengaduanCard(dynamic pengaduan) {
    final categoryColor = getCategoryColor(pengaduan.kategoriKekerasan);
    final categoryIcon = getCategoryIcon(pengaduan.kategoriKekerasan);
    final beautifiedCategory = beautifyCategory(pengaduan.kategoriKekerasan);
    final PengaduanStatus currentStatus =
        _getStatusFromString(pengaduan.status);

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: double.infinity,
        minHeight: 100,
      ),
      child: Container(
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
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              _navigateToDetail(pengaduan);
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: categoryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          categoryIcon,
                          color: categoryColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              beautifiedCategory,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Korban: ${pengaduan.namaKorban ?? 'Tidak diketahui'}',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: getStatusColor(currentStatus).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          getStatusText(currentStatus),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: getStatusColor(currentStatus),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    pengaduan.aduan ?? 'Tidak ada isi pengaduan',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        pengaduan.createdAt != null
                            ? DateFormat('dd MMM yyyy, HH:mm')
                                .format(pengaduan.createdAt)
                            : 'Tanggal tidak tersedia',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () {
                          _navigateToDetail(pengaduan);
                        },
                        icon: const Icon(Icons.visibility_rounded, size: 16),
                        label: Text(
                          'Lihat Detail',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: categoryColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Builds the empty state widget when no reports are found
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              Icons.inbox_rounded,
              size: 60,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _searchQuery.isNotEmpty ? 'Tidak ada hasil' : 'Belum ada laporan',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty
                ? 'Coba ubah kata kunci pencarian'
                : 'Laporan pengaduan akan muncul di sini',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  // Builds the error state widget when an error occurs
  Widget _buildErrorState(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              Icons.error_outline_rounded,
              size: 60,
              color: Colors.red[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Terjadi Kesalahan',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.red[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              final authProvider = context.read<AuthProvider>();
              context
                  .read<PengaduansProvider>()
                  .loadAllPengaduans(authProvider);
            },
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Coba Lagi'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
