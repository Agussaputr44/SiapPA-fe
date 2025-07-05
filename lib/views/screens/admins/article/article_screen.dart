import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siappa/providers/articles_provider.dart';
import 'package:siappa/providers/auth_provider.dart';
import 'package:siappa/providers/filters_provider.dart';
import 'package:siappa/views/screens/admins/widgets/app_bar_widget.dart';
import 'package:siappa/views/screens/admins/article/article_card_widget.dart';
import 'package:siappa/views/widgets/loading_widget.dart';
import '../widgets/filter_widget.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({Key? key}) : super(key: key);

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final authProvider = context.read<AuthProvider>();
      context.read<ArticlesProvider>().loadAllArticles(authProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final articlesProvider = context.watch<ArticlesProvider>();
    final filter = context.watch<FiltersProvider>();
    final _isLoading = context.watch<ArticlesProvider>().isLoading;

    return LoadingWidget(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBarWidget(
          title: 'Artikel',
          subtitle:
              'Sistem Informasi Aduan dan Perlindungan Perempuan dan Anak',
          onBack: () => Navigator.of(context).pop(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: articlesProvider.articles.isEmpty
              ? const Center(child: Text("Tidak ada data artikel."))
              : SingleChildScrollView(
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
                        onYearChanged: context.read<FiltersProvider>().setYear,
                      ),
                      const SizedBox(height: 10),
                      // Render artikel dari provider
                      ...articlesProvider.articles.map((artikel) {
                        return ArticleCardWidget(
                          title: artikel.judul,
                          // Tambahkan kategori kalau ada di model
                          date: artikel.createdAt?.toIso8601String() ??
                              'Tanggal tidak tersedia',
                          onDetail: () async {
                            final result = await Navigator.of(context)
                                .pushNamed('/artikel/detail', arguments: {
                              'id': artikel.id,
                              'title': artikel.judul,
                              'imageUrl': artikel.foto ?? '',
                              'content': artikel.isi,
                            });

                            if (result == true) {
                              final authProvider = context.read<AuthProvider>();
                              await context
                                  .read<ArticlesProvider>()
                                  .loadAllArticles(authProvider);
                            }
                          },

                          bgCircleColor: const Color(0xFFF48FB1),
                          bgCircleShadow:
                              const Color(0xFFF48FB1).withOpacity(0.2),
                        );
                      }).toList(),
                    ],
                  ),
                ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result =
                await Navigator.of(context).pushNamed('/artikel/add');

            if (result == true) {
              final authProvider = context.read<AuthProvider>();
              await context
                  .read<ArticlesProvider>()
                  .loadAllArticles(authProvider);
            }
          },
          child: const Icon(Icons.add),
          backgroundColor: const Color(0xFFF48FB1),
        ),
      ),
    );
  }
}

// Dummy filter options
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
