import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:siappa/views/widgets/loading_widget.dart';

import '../../../../configs/api_config.dart';
import '../../../../models/articles_model.dart';
import '../../../../providers/articles_provider.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../utils/app_colors.dart';

class AllArticleUsersScreen extends StatelessWidget {
  const AllArticleUsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Load articles saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final articlesProvider =
          Provider.of<ArticlesProvider>(context, listen: false);
      articlesProvider.loadAllArticles(authProvider);
    });

    return Consumer<ArticlesProvider>(
      builder: (context, articlesProvider, _) {
        final isLoading = articlesProvider.isLoading;
        final articles = articlesProvider.articles;

        return LoadingWidget(
          isLoading: isLoading,
          child: Scaffold(
            appBar: AppBar(
              title:  Text(
                'Semua Artikel',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: Colors.grey[50],
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black),
            ),
            body: articles.isEmpty
                ?  Center(
                    child: Text(
                      'Belum ada artikel tersedia.',
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      return _buildArticleCard(context, articles[index]);
                    },
                  ),
          ),
        );
      },
    );
  }

  Widget _buildArticleCard(BuildContext context, ArticlesModel article) {
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
                  child: (article.foto != null && article.foto!.isNotEmpty)
                      ? Image.network(
                          ApiConfig.baseUrl + article.foto!,
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
                      style:  GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      article.isi ?? 'Deskripsi tidak tersedia',
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
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 5),
                        Text(
                          _formatDate(article.createdAt),
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
