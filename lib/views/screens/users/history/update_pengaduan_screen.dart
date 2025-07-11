import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:siappa/configs/api_config.dart';
import 'package:siappa/models/pengaduans_model.dart';
import 'package:siappa/providers/auth_provider.dart';
import 'package:siappa/providers/pengaduans_provider.dart';
import 'package:siappa/providers/upload_media_provider.dart';
import 'package:siappa/utils/app_colors.dart';
import 'package:siappa/views/widgets/loading_widget.dart';
import 'package:siappa/views/widgets/messages_widget.dart';
import 'package:siappa/views/widgets/tittle_custom_widget.dart';

class DropdownOption {
  final String displayText;
  final String databaseValue;

  const DropdownOption({
    required this.displayText,
    required this.databaseValue,
  });
}

class PengaduanUsersScreen extends StatefulWidget {
  final PengaduansModel? existingPengaduan;

  const PengaduanUsersScreen({super.key, this.existingPengaduan});

  @override
  State<PengaduanUsersScreen> createState() => _PengaduanUsersScreenState();
}

class _PengaduanUsersScreenState extends State<PengaduanUsersScreen> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _aduanController = TextEditingController();
  final _harapanController = TextEditingController();

  List<File> _selectedFiles = [];
  List<String> _existingFiles = [];
  DropdownOption? _selectedKategori;
  DropdownOption? _selectedKorban;

  final List<DropdownOption> _kategoriOptions = [
    const DropdownOption(
        displayText: 'Kekerasan Fisik', databaseValue: 'kekerasan_fisik'),
    const DropdownOption(
        displayText: 'Kekerasan Seksual', databaseValue: 'kekerasan_seksual'),
    const DropdownOption(
        displayText: 'Kekerasan Psikis', databaseValue: 'kekerasan_psikis'),
    const DropdownOption(
        displayText: 'Kekerasan Ekonomi', databaseValue: 'kekerasan_ekonomi'),
    const DropdownOption(
        displayText: 'Kekerasan Sosial', databaseValue: 'kekerasan_sosial'),
  ];

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

    if (widget.existingPengaduan != null) {
      _namaController.text = widget.existingPengaduan!.namaKorban;
      _alamatController.text = widget.existingPengaduan!.alamat;
      _aduanController.text = widget.existingPengaduan!.aduan;
      _harapanController.text = widget.existingPengaduan!.harapan;

      _selectedKategori = _kategoriOptions.firstWhere(
        (e) => e.databaseValue == widget.existingPengaduan!.kategoriKekerasan,
        orElse: () => _kategoriOptions.first,
      );

      _selectedKorban = _korbanOptions.firstWhere(
        (e) => e.databaseValue == widget.existingPengaduan!.korban,
        orElse: () => _korbanOptions.first,
      );

      _existingFiles = List.from(widget.existingPengaduan!.evidencePaths);
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    _aduanController.dispose();
    _harapanController.dispose();
    super.dispose();
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'mp4', 'mov', 'avi'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFiles.addAll(
          result.files.where((f) => f.path != null).map((f) => File(f.path!)),
        );
      });
    }
  }

  Future<void> _submitPengaduan() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final uploadProvider =
        Provider.of<UploadMediaProvider>(context, listen: false);
    uploadProvider.init(authProvider);

    if (!_formKey.currentState!.validate()) {
      MessagesWidget.showError(context, "Harap lengkapi semua kolom.");
      return;
    }

    if (_selectedFiles.isEmpty && _existingFiles.isEmpty) {
      MessagesWidget.showError(
          context, "Harap unggah minimal satu file bukti.");
      return;
    }

    final validExtensions = ['jpg', 'jpeg', 'png', 'gif', 'mp4', 'mov', 'avi'];
    for (final file in _selectedFiles) {
      final ext = file.path.split('.').last.toLowerCase();
      if (!validExtensions.contains(ext)) {
        MessagesWidget.showError(context, "File tidak didukung: .$ext");
        return;
      }
    }

    final pengaduanProvider = context.read<PengaduansProvider>();

    try {
      List<String> uploadedUrls = [];

      if (_selectedFiles.isNotEmpty) {
        await uploadProvider.upload(_selectedFiles);
        uploadedUrls = uploadProvider.uploadedFiles;
      }

      final evidencePaths = [..._existingFiles, ...uploadedUrls];

      if (widget.existingPengaduan == null) {
        await pengaduanProvider.addPengaduan(
          namaKorban: _namaController.text,
          alamat: _alamatController.text,
          aduan: _aduanController.text,
          kategoriKekerasan: _selectedKategori!.databaseValue,
          korban: _selectedKorban!.databaseValue,
          harapan: _harapanController.text,
          evidencePaths: evidencePaths,
        );
        MessagesWidget.showSuccess(context, "Pengaduan berhasil dikirim!");
      } else {
        await pengaduanProvider.updatePengaduan(
          id: widget.existingPengaduan!.id.toString(),
          namaKorban: _namaController.text,
          alamat: _alamatController.text,
          aduan: _aduanController.text,
          kategoriKekerasan: _selectedKategori!.databaseValue,
          korban: _selectedKorban!.databaseValue,
          harapan: _harapanController.text,
          evidencePaths: evidencePaths,
        );
        MessagesWidget.showSuccess(context, "Pengaduan berhasil diperbarui!");
      }

      Navigator.of(context).pop(true);
    } catch (e) {
      MessagesWidget.showError(
          context, "Gagal mengirim pengaduan: ${e.toString()}");
    }
  }

  bool _isImage(String path) {
    final lower = path.toLowerCase();
    return lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.gif');
  }

  bool _isImageFile(File file) {
    return _isImage(file.path);
  }

  @override
  Widget build(BuildContext context) {
    final pengaduanProvider = context.watch<PengaduansProvider>();
    final uploadProvider = context.watch<UploadMediaProvider>();
    final isLoading = pengaduanProvider.isLoading || uploadProvider.isLoading;

    InputDecoration formDecoration(String label) {
      return InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.grey[600],
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.existingPengaduan == null
              ? "Tambah Pengaduan"
              : "Edit Pengaduan",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black87,
      ),
      backgroundColor: Colors.grey[100],
      body: LoadingWidget(
        isLoading: isLoading,
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Form Pengaduan',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _namaController,
                    decoration: formDecoration('Nama Korban'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Wajib diisi' : null,
                    style: GoogleFonts.poppins(
                        fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _alamatController,
                    decoration: formDecoration('Alamat Lengkap Korban'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Wajib diisi' : null,
                    style: GoogleFonts.poppins(
                        fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<DropdownOption>(
                    value: _selectedKategori,
                    decoration: formDecoration('Jenis Kekerasan'),
                    items: _kategoriOptions
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                e.displayText,
                                style: GoogleFonts.poppins(
                                    fontSize: 14, color: Colors.black87),
                              ),
                            ))
                        .toList(),
                    onChanged: (val) => setState(() => _selectedKategori = val),
                    validator: (val) =>
                        val == null ? 'Pilih jenis kekerasan' : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<DropdownOption>(
                    value: _selectedKorban,
                    decoration: formDecoration('Jenis Korban'),
                    items: _korbanOptions
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                e.displayText,
                                style: GoogleFonts.poppins(
                                    fontSize: 14, color: Colors.black87),
                              ),
                            ))
                        .toList(),
                    onChanged: (val) => setState(() => _selectedKorban = val),
                    validator: (val) =>
                        val == null ? 'Pilih jenis korban' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _aduanController,
                    decoration: formDecoration('Isi Pengaduan'),
                    maxLines: 3,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Wajib diisi' : null,
                    style: GoogleFonts.poppins(
                        fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _harapanController,
                    decoration: formDecoration('Harapan'),
                    maxLines: 2,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Wajib diisi' : null,
                    style: GoogleFonts.poppins(
                        fontSize: 14, color: Colors.black87),
                  ),
                  // Ganti bagian bukti pendukung dengan kode ini (mulai dari Text 'Bukti Pendukung'):

                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.folder_open_rounded,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Bukti Pendukung',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Upload foto atau video sebagai bukti pendukung',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Upload Button dengan design yang lebih menarik
                        GestureDetector(
                          onTap: _pickFiles,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.3),
                                width: 2,
                                style: BorderStyle.solid,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.08),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Icon(
                                    Icons.cloud_upload_rounded,
                                    color: AppColors.primary,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Upload Bukti',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Klik untuk memilih file',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // File Grid dengan design yang lebih baik
                        if (_existingFiles.isNotEmpty ||
                            _selectedFiles.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'File yang dipilih (${_existingFiles.length + _selectedFiles.length})',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 8),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 1.2,
                                ),
                                itemCount: _existingFiles.length +
                                    _selectedFiles.length,
                                itemBuilder: (context, index) {
                                  if (index < _existingFiles.length) {
                                    final evidencePath = _existingFiles[index];
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Container(
                                              width: double.infinity,
                                              height: double.infinity,
                                              color: Colors.grey[100],
                                              child: _isImage(evidencePath)
                                                  ? Image.network(
                                                      ApiConfig.baseUrl +
                                                          evidencePath,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return Center(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                  Icons
                                                                      .broken_image_rounded,
                                                                  color: Colors
                                                                          .grey[
                                                                      400],
                                                                  size: 32),
                                                              const SizedBox(
                                                                  height: 4),
                                                              Text(
                                                                'Gagal memuat',
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                          .grey[
                                                                      600],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    )
                                                  : Center(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                              Icons
                                                                  .videocam_rounded,
                                                              size: 32,
                                                              color: Colors
                                                                  .grey[600]),
                                                          const SizedBox(
                                                              height: 4),
                                                          Text(
                                                            'Video',
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .grey[600],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 6,
                                            right: 6,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _existingFiles
                                                      .removeAt(index);
                                                });
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.2),
                                                      blurRadius: 4,
                                                      offset:
                                                          const Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: const Icon(
                                                  Icons.close_rounded,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    final file = _selectedFiles[
                                        index - _existingFiles.length];
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: Container(
                                              width: double.infinity,
                                              height: double.infinity,
                                              color: Colors.grey[100],
                                              child: _isImageFile(file)
                                                  ? Image.file(
                                                      file,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Center(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                              Icons
                                                                  .videocam_rounded,
                                                              size: 32,
                                                              color: Colors
                                                                  .grey[600]),
                                                          const SizedBox(
                                                              height: 4),
                                                          Text(
                                                            'Video',
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .grey[600],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 6,
                                            right: 6,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _selectedFiles.remove(file);
                                                });
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.2),
                                                      blurRadius: 4,
                                                      offset:
                                                          const Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: const Icon(
                                                  Icons.close_rounded,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withOpacity(0.8),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _submitPengaduan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            widget.existingPengaduan == null
                                ? Icons.send_rounded
                                : Icons.update_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.existingPengaduan == null
                                ? "Kirim Pengaduan"
                                : "Perbarui Pengaduan",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
