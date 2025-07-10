import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:siappa/configs/api_config.dart';
import '../../../../models/articles_model.dart';
import '../../../../utils/app_colors.dart';

class DetailArticleUsersScreen extends StatelessWidget {
  const DetailArticleUsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get article data from arguments
    final ArticlesModel? article =
        ModalRoute.of(context)?.settings.arguments as ArticlesModel?;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Detail Artikel',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.grey[50],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () {
              _shareArticle(context, article);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Article Image
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: article?.foto != null && article!.foto!.isNotEmpty
                    ? Image.network(
                        ApiConfig.baseUrl + article!.foto!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.primary.withOpacity(0.1),
                            child: Icon(
                              Icons.article,
                              size: 80,
                              color: AppColors.primary,
                            ),
                          );
                        },
                      )
                    : Container(
                        color: AppColors.primary.withOpacity(0.1),
                        child: Icon(
                          Icons.article,
                          size: 80,
                          color: AppColors.primary,
                        ),
                      ),
              ),
            ),

            // Article Content
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // judul
                  Text(
                    article?.judul ?? 'Judul Artikel',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Date and Author Info
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 5),
                      Text(
                        _formatDate(article?.createdAt),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Icon(
                        Icons.person,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Admin',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Content
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // const SizedBox(height: 16),
                        Text(
                          article?.isi ?? 'Konten artikel tidak tersedia.',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Share Button (Full Width)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _shareArticle(context, article);
                      },
                      icon: const Icon(Icons.share, size: 20),
                      label: Text(
                        'Bagikan Artikel',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption(
      BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: AppColors.primary,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Tanggal tidak tersedia';

    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void _shareArticle(BuildContext context, ArticlesModel? article) {
    if (article != null) {
      final String shareText = '''
📖 ${article.judul}

${article.isi}

Dibagikan dari aplikasi SIAPPA - Sistem Informasi Aplikasi Perlindungan Perempuan dan Anak
      ''';

      Share.share(
        shareText,
        subject: article.judul,
      );
    }
  }

  void _copyToClipboard(BuildContext context, ArticlesModel? article) {
    if (article != null) {
      final String shareText = '''
📖 ${article.judul}

${article.isi}

Dibagikan dari aplikasi SIAPPA
      ''';

      Clipboard.setData(ClipboardData(text: shareText));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Link artikel berhasil disalin'),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _shareViaMessage(BuildContext context, ArticlesModel? article) {
    if (article != null) {
      final String shareText = '''
📖 ${article.judul}

${article.isi}

Dibagikan dari aplikasi SIAPPA
      ''';

      Share.share(
        shareText,
        subject: article.judul,
      );
    }
  }

  void _shareViaEmail(BuildContext context, ArticlesModel? article) {
    if (article != null) {
      final String shareText = '''
📖 ${article.judul}

${article.isi}

Dibagikan dari aplikasi SIAPPA - Sistem Informasi Aplikasi Perlindungan Perempuan dan Anak
      ''';

      Share.share(
        shareText,
        subject: 'Artikel: ${article.judul}',
      );
    }
  }
}
