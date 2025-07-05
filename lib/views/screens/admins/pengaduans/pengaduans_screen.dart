import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siappa/views/screens/admins/widgets/app_bar_widget.dart';
import 'package:siappa/views/screens/admins/widgets/filter_widget.dart';
import 'package:siappa/views/screens/admins/widgets/report_card.dart';
import 'package:siappa/providers/filters_provider.dart';
import 'package:siappa/views/widgets/loading_widget.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/pengaduans_provider.dart';
import 'package:intl/intl.dart';

const List<String> categories = [
  "All Categories",
  "Fisik",
  "Psikis",
  "Sosial",
  "Ekonomi",
  "Seksual",
  "Perundungan"
];

const List<String> months = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December"
];

const List<String> years = ["2024", "2025", "2026"];

class PengaduansScreen extends StatefulWidget {
  const PengaduansScreen({Key? key}) : super(key: key);

  @override
  State<PengaduansScreen> createState() => _PengaduansScreenState();
}

class _PengaduansScreenState extends State<PengaduansScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final authProvider = context.read<AuthProvider>();
      context.read<PengaduansProvider>().loadAllPengaduans(authProvider);
    });
  }

  String beautifyCategory(String kategori) {
    return kategori.replaceAll('_', ' ').split(' ').map((e) {
      if (e.isEmpty) return '';
      return e[0].toUpperCase() + e.substring(1);
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final pengaduansProvider = context.watch<PengaduansProvider>();
    final filter = context.watch<FiltersProvider>();

    final pengaduans = pengaduansProvider.pengaduans;
    final isLoading = pengaduansProvider.isLoading;

    return LoadingWidget(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBarWidget(
          title: 'Laporan',
          subtitle:
              'Sistem Informasi Aduan dan Perlindungan Perempuan dan Anak',
          onBack: () => Navigator.of(context).pop(),
        ),
        body: pengaduansProvider.errorMessage != null
                ? Center(child: Text(pengaduansProvider.errorMessage!))
                : pengaduans.isEmpty
                    ? const Center(child: Text("Tidak ada data Laporan."))
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              FilterWidget(
                                categories: categories,
                                selectedCategory: filter.category,
                                months: months,
                                selectedMonth: filter.month,
                                years: years,
                                selectedYear: filter.year,
                                onCategoryChanged:
                                    context.read<FiltersProvider>().setCategory,
                                onMonthChanged:
                                    context.read<FiltersProvider>().setMonth,
                                onYearChanged:
                                    context.read<FiltersProvider>().setYear,
                              ),
                              const SizedBox(height: 10),
                              ...pengaduans.map((pengaduan) {
                                return ReportCard(
                                  imageAsset: 'assets/icons/ic_fisik.png',
                                  title: pengaduan.kategoriKekerasan,
                                  subtitle:
                                      'Pelapor: Anonim\nTanggal: ${DateFormat('dd MMM yyyy').format(pengaduan.createdAt)}',
                                  color: const Color(0xFF7986CB),
                                  onDetail: () {
                                    // Tampilkan detail lebih lengkap di page lain
                                  },
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ),
      ),
    );
  }
}
