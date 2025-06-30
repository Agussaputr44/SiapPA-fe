import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siappa/providers/filters_provider.dart';
import 'package:siappa/views/screens/admins/widgets/app_bar_widget.dart';
import 'package:siappa/views/screens/admins/article/article_card_widget.dart';
import '../widgets/filter_widget.dart';

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

class ArticleScreen extends StatelessWidget {
  const ArticleScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final filter = context.watch<FiltersProvider>();

    return Scaffold(
      appBar: AppBarWidget(
        title: 'Artikel',
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
              // Example Article Card(s)
              ArticleCardWidget(
                title: 'Artikel 1',
                subtitle: '1 Artikel',
                date: '2025-06-20',
                onDetail: () {
                  Navigator.of(context).pushNamed('/artikel/detail', arguments: {
                    'title': 'Artikel 1',
                    'imageUrl': 'https://example.com/image1.jpg',
                    'content': 'Konten artikel 1',
                  });
                },
                bgCircleColor: const Color(0xFFF48FB1),
                bgCircleShadow: const Color(0xFFF48FB1).withOpacity(0.2),
              ),
              // Tambahkan ArticleCardWidget lain di sini sesuai kebutuhan
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/artikel/add');
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFFF48FB1),
      ),
    );
  }
}