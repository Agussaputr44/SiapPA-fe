import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:siappa/configs/api_config.dart';
import 'package:siappa/providers/articles_provider.dart';
import 'package:siappa/providers/upload_media_provider.dart';
import 'package:siappa/views/screens/admins/widgets/app_bar_widget.dart';
import 'package:siappa/views/widgets/loading_widget.dart';
import 'package:siappa/views/widgets/messages_widget.dart';

import '../../../../providers/auth_provider.dart';

class UpdateArticleScreen extends StatefulWidget {
  const UpdateArticleScreen({super.key});

  @override
  State<UpdateArticleScreen> createState() => _UpdateArticleScreenState();
}

class _UpdateArticleScreenState extends State<UpdateArticleScreen> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _isiController = TextEditingController();
  File? _selectedFile;
  String? _existingImageUrl;
  late int _articleId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _articleId = args['id'];
      _judulController.text = args['title'] ?? '';
      _isiController.text = args['content'] ?? '';
      _existingImageUrl = args['imageUrl'] ?? '';
    }
  }

  @override
  void dispose() {
    _judulController.dispose();
    _isiController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg', 'gif', 'mp4', 'mov', 'avi'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _submitArticle(BuildContext context) async {
    final uploadProvider = context.read<UploadMediaProvider>();
     final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final articleProvider = context.read<ArticlesProvider>();
    uploadProvider.init(authProvider);

    final judul = _judulController.text.trim();
    final isi = _isiController.text.trim();

    if (judul.isEmpty || isi.isEmpty) {
      MessagesWidget.showError(context, "Judul dan konten harus diisi.");
      return;
    }

    if (_selectedFile == null && _existingImageUrl == null) {
      MessagesWidget.showError(context, "File atau URL gambar/video harus diisi.");
      return;
    }

    try {
      String? fotoUrl = _existingImageUrl;
      if (_selectedFile != null) {
        // Validasi tipe file
        final validExtensions = ['jpg', 'jpeg', 'png', 'gif', 'mp4', 'mov', 'avi'];
        final fileExtension = _selectedFile!.path.split('.').last.toLowerCase();

        if (!validExtensions.contains(fileExtension)) {
          MessagesWidget.showError(context, "Tipe file tidak didukung.");
          return;
        }

        await uploadProvider.upload([_selectedFile!]);

        if (uploadProvider.uploadedFiles.isEmpty) {
          throw Exception('File gagal diupload.');
        }

        fotoUrl = uploadProvider.uploadedFiles.first;
      }

      await articleProvider.updateArticle(
        _articleId,
        judul,
        isi,
        fotoUrl!,
      );

      MessagesWidget.showSuccess(context, "Artikel berhasil diperbarui.");

      // Navigate to /artikel and remove all previous routes
      Navigator.of(context).pushNamedAndRemoveUntil('/artikel', (route) => false);
    } catch (e) {
      MessagesWidget.showError(context, "Terjadi kesalahan saat memperbarui artikel.");
    }
  }

  bool _isImage(String path) {
    final lowerPath = path.toLowerCase();
    return lowerPath.endsWith('.jpg') ||
        lowerPath.endsWith('.jpeg') ||
        lowerPath.endsWith('.png') ||
        lowerPath.endsWith('.gif');
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<UploadMediaProvider>().isLoading ||
        context.watch<ArticlesProvider>().isLoading;

    OutlineInputBorder pinkBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFFF48FB1), width: 1.5),
      borderRadius: BorderRadius.circular(8),
    );

    return LoadingWidget(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBarWidget(
          title: "Update Artikel",
          subtitle: "Sistem Informasi Aduan dan Perlindungan Perempuan dan Anak",
          onBack: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        body:  Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _judulController,
                    style: GoogleFonts.poppins(),
                    decoration: InputDecoration(
                      hintText: 'Nama Artikel',
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w400,
                      ),
                      enabledBorder: pinkBorder,
                      focusedBorder: pinkBorder,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: _isiController,
                    style: GoogleFonts.poppins(),
                    maxLines: 12,
                    decoration: InputDecoration(
                      hintText: 'Konten Artikel',
                      hintStyle: GoogleFonts.poppins(
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w400,
                      ),
                      enabledBorder: pinkBorder,
                      focusedBorder: pinkBorder,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFF48FB1), width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Upload Foto/Video",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Center(
                          child: _selectedFile != null
                              ? Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: _isImage(_selectedFile!.path)
                                          ? Image.file(
                                              _selectedFile!,
                                              width: 160,
                                              height: 160,
                                              fit: BoxFit.cover,
                                            )
                                          : Container(
                                              width: 160,
                                              height: 160,
                                              color: Colors.grey[200],
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.videocam, size: 40, color: Colors.grey[700]),
                                                  const SizedBox(height: 6),
                                                  Text(
                                                    'Video',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      color: Colors.grey[700],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedFile = null;
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.redAccent,
                                          ),
                                          child: const Icon(Icons.close, size: 16, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : _existingImageUrl != null && _existingImageUrl!.isNotEmpty
                                  ? Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: _isImage(_existingImageUrl!)
                                              ? Image.network(
                                                  '${ApiConfig.baseUrl}$_existingImageUrl',
                                                  width: 160,
                                                  height: 160,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) => Container(
                                                    width: 160,
                                                    height: 160,
                                                    color: Colors.grey[300],
                                                    child: const Icon(Icons.broken_image, size: 48, color: Colors.grey),
                                                  ),
                                                )
                                              : Container(
                                                  width: 160,
                                                  height: 160,
                                                  color: Colors.grey[200],
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Icon(Icons.videocam, size: 40, color: Colors.grey[700]),
                                                      const SizedBox(height: 6),
                                                      Text(
                                                        'Video',
                                                        style: GoogleFonts.poppins(
                                                          fontSize: 12,
                                                          color: Colors.grey[700],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                        ),
                                        Positioned(
                                          top: 4,
                                          right: 4,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _existingImageUrl = null;
                                              });
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.redAccent,
                                              ),
                                              child: const Icon(Icons.close, size: 16, color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Icon(
                                      Icons.cloud_upload_rounded,
                                      size: 54,
                                      color: Colors.grey[300],
                                    ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: SizedBox(
                            width: 130,
                            height: 36,
                            child: ElevatedButton.icon(
                              onPressed: _pickFile,
                              icon: const Icon(Icons.insert_drive_file_rounded, size: 20, color: Colors.white70),
                              label: Text(
                                'Pilih',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Colors.grey[400],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 42,
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFF48FB1), width: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),
                              backgroundColor: Colors.white,
                            ),
                            child: Text(
                              'Batal',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFFD81B60),
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: SizedBox(
                          height: 42,
                          child: ElevatedButton(
                            onPressed: () => _submitArticle(context),
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: const Color(0xFFF48FB1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),
                            ),
                            child: Text(
                              'Simpan',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }
}