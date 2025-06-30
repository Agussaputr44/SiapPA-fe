import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siappa/views/screens/admins/widgets/app_bar_widget.dart';
import 'package:siappa/views/screens/admins/widgets/filter_widget.dart';
import 'package:siappa/views/screens/admins/widgets/report_card.dart';
import 'package:siappa/providers/filters_provider.dart';

// Dummy data for demonstration
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
  "January", "February", "March", "April", "May", "June",
  "July", "August", "September", "October", "November", "December"
];

const List<String> years = [
  "2024", "2025", "2026"
];

class LaporanScreen extends StatelessWidget {
  const LaporanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filter = context.watch<FiltersProvider>();

    return Scaffold(
      appBar: AppBarWidget(
        title: 'Laporan Pengaduan',
        subtitle: 'Sistem Informasi Aduan dan Perlindungan Perempuan dan Anak',
        onBack: () => Navigator.of(context).pop(),
      ),
      body: Padding(
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
                onCategoryChanged: context.read<FiltersProvider>().setCategory,
                onMonthChanged: context.read<FiltersProvider>().setMonth,
                onYearChanged: context.read<FiltersProvider>().setYear,
              ),
              const SizedBox(height: 10),
              ReportCard(
                imageAsset: 'assets/icons/ic_fisik.png',
                title: 'Kekerasan Psikis',
                subtitle: '5 Laporan',
                additionalCount: 5,
                color: const Color(0xFF7986CB),
                onDetail: () {},
              ),
              // Tambahkan ReportCard lain sesuai kebutuhan
            ],
          ),
        ),
      ),
    );
  }
}