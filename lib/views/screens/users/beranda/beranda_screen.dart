import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siappa/configs/api_config.dart';
import 'package:siappa/models/articles_model.dart';
import '../../../../providers/articles_provider.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../utils/app_colors.dart';
import '../../../widgets/tittle_custom_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadArticles();
    });
  }

  void _loadArticles() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final articlesProvider =
        Provider.of<ArticlesProvider>(context, listen: false);
    articlesProvider.loadAllArticles(authProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TitleCustom(title: "Beranda"),
        automaticallyImplyLeading: false,
      ),
      body:  SingleChildScrollView(
          child: Column(
            children: [
              // Logo Section
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Image.asset(
                  "assets/images/logo.png",
                  height: 120,
                  width: 150,
                ),
              ),

              // Quote Section
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Text(
                  '" Lindungi Perempuan dan Anak. Jadilah Pelopor Yang Memutus Mata Rantai Kekerasan Terhadap Perempuan Dan Anak "',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontStyle: FontStyle.italic,
                    fontSize: 13,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Articles Section
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Artikel Terbaru',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to all articles page
                            Navigator.pushNamed(context, '/users/artikel/all');
                          },
                          child: Text(
                            'Lihat Semua',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontFamily: 'Poppins',
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // Article List
                    Consumer<ArticlesProvider>(
                      builder: (context, articlesProvider, child) {
                        if (articlesProvider.isLoading) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        if (articlesProvider.articles.isEmpty) {
                          return Container(
                            padding: const EdgeInsets.all(20),
                            child: const Text(
                              'Belum ada artikel tersedia',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }

                        // Show only first 5 articles for home screen
                        final displayedArticles =
                            articlesProvider.articles.take(5).toList();

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: displayedArticles.length,
                          itemBuilder: (context, index) {
                            final article = displayedArticles[index];
                            return _buildArticleCard(article);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }

  Widget _buildArticleCard(ArticlesModel article) {
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
          // Navigate to article detail
          Navigator.pushNamed(
            context,
            '/users/artikel/detail',
            arguments: article,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Article Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 80,
                  height: 80,
                  color: AppColors.primary.withOpacity(0.1),
                  child: article?.foto != null && article!.foto!.isNotEmpty
                      ? Image.network(
                          ApiConfig.baseUrl + article!.foto!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.article,
                              size: 30,
                              color: AppColors.primary,
                            );
                          },
                        )
                      : Icon(
                          Icons.article,
                          size: 30,
                          color: AppColors.primary,
                        ),
                ),
              ),
              const SizedBox(width: 15),

              // Article Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.judul ?? 'Judul Tidak Tersedia',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      article.isi ?? 'Deskripsi tidak tersedia',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontFamily: 'Poppins',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 5),
                        Text(
                          _formatDate(article.createdAt),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[500],
                            fontFamily: 'Poppins',
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
