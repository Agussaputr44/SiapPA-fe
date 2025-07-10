import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// Ganti path ini sesuai dengan struktur proyek Anda
import '../../../../helpers/dropdown_option_helper.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/pengaduans_provider.dart';
import '../../../../providers/upload_media_provider.dart';
import '../../../../utils/app_colors.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/messages_widget.dart';
import '../../../widgets/tittle_custom_widget.dart';
class DropdownOption {
  final String displayText; // Text shown to the user
  final String databaseValue; // Value sent to the database

  const DropdownOption({required this.displayText, required this.databaseValue});
}

class PengaduanUsersScreen extends StatefulWidget {
  const PengaduanUsersScreen({Key? key}) : super(key: key);

  @override
  State<PengaduanUsersScreen> createState() => _PengaduanUsersScreenState();
}

class _PengaduanUsersScreenState extends State<PengaduanUsersScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers untuk setiap input field
  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _aduanController = TextEditingController();
  final _harapanController = TextEditingController();

  // Variabel state untuk menyimpan file yang dipilih dan pilihan dropdown
  List<File> _selectedFiles = [];
  DropdownOption? _selectedKategori;
  DropdownOption? _selectedKorban;

  // Daftar opsi untuk dropdown Kategori Kekerasan
  final List<DropdownOption> _kategoriOptions = [
    const DropdownOption(displayText: 'Kekerasan Fisik', databaseValue: 'kekerasan_fisik'),
    const DropdownOption(displayText: 'Kekerasan Seksual', databaseValue: 'kekerasan_seksual'),
    const DropdownOption(displayText: 'Kekerasan Psikis', databaseValue: 'kekerasan_psikis'),
    const DropdownOption(displayText: 'Kekerasan Ekonomi', databaseValue: 'kekerasan_ekonomi'),
    const DropdownOption(displayText: 'Kekerasan Sosial', databaseValue: 'kekerasan_sosial'),
  ];

  // Daftar opsi untuk dropdown Korban
  final List<DropdownOption> _korbanOptions = [
    const DropdownOption(displayText: 'Anak Laki-laki', databaseValue: 'anak_laki_laki'),
    const DropdownOption(displayText: 'Anak Perempuan', databaseValue: 'anak_perempuan'),
    const DropdownOption(displayText: 'Perempuan Dewasa', databaseValue: 'perempuan'),
  ];

  @override
  void dispose() {
    // Selalu dispose controller untuk menghindari memory leak
    _namaController.dispose();
    _alamatController.dispose();
    _aduanController.dispose();
    _harapanController.dispose();
    super.dispose();
  }

  /// Fungsi untuk membuka pemilih file dan menyimpan file yang dipilih ke state
  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg', 'gif', 'mp4', 'mov', 'avi'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFiles.addAll(
            result.files.where((f) => f.path != null).map((f) => File(f.path!)));
      });
    }
  }

  /// Fungsi untuk memvalidasi, mengunggah file, dan mengirim data pengaduan
  Future<void> _submitPengaduan() async {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);

       final _uploadProvider =
        Provider.of<UploadMediaProvider>(context, listen: false);
 _uploadProvider.init(authProvider);
  // 1. Validasi form seperti biasa
  if (!_formKey.currentState!.validate()) {
    MessagesWidget.showError(context, "Harap lengkapi semua kolom yang wajib diisi.");
    return;
  }
  if (_selectedFiles.isEmpty) {
    MessagesWidget.showError(context, "Harap unggah setidaknya satu file bukti.");
    return;
  }

  // 2. (PENYESUAIAN) Validasi ekstensi untuk SETIAP file sebelum mengunggah
  final validExtensions = ['jpg', 'jpeg', 'png', 'gif', 'mp4', 'mov', 'avi'];
  for (final file in _selectedFiles) {
    final fileExtension = file.path.split('.').last.toLowerCase();
    if (!validExtensions.contains(fileExtension)) {
      MessagesWidget.showError(context, "Tipe file tidak didukung: .$fileExtension");
      return; // Hentikan proses jika ada satu file yang tidak valid
    }
  }

  // Menggunakan context.read lebih ringkas di dalam callback
  final pengaduanProvider = context.read<PengaduansProvider>();

  try {
    // 3. Proses unggah dan pengiriman data (logika ini sudah benar)
    print("Udah sampe sini");
    await _uploadProvider.upload(_selectedFiles);

    if (_uploadProvider.uploadedFiles.isEmpty) {
      throw Exception('File bukti gagal diunggah. Silakan coba lagi.');
    }
    
    await pengaduanProvider.addPengaduan(
      namaKorban: _namaController.text,
      alamat: _alamatController.text,
      aduan: _aduanController.text,
      kategoriKekerasan: _selectedKategori!.databaseValue,
      korban: _selectedKorban!.databaseValue,
      harapan: _harapanController.text,
      evidencePaths: _uploadProvider.uploadedFiles, // Mengirim semua URL file
    );

    MessagesWidget.showSuccess(context, 'Pengaduan berhasil dikirim!');

    // 4. Reset form setelah berhasil
    // _uploadProvider.reset();
    _formKey.currentState!.reset();
    setState(() {
      _selectedFiles.clear();
      _selectedKategori = null;
      _selectedKorban = null;
      _namaController.clear();
      _alamatController.clear();
      _aduanController.clear();
      _harapanController.clear();
    });

  } catch (e) {
    print("Gagal mengirim pengaduan: ${e.toString()}");
    // Memberikan pesan error yang lebih spesifik jika memungkinkan
    MessagesWidget.showError(context, "Gagal mengirim pengaduan: ${e.toString()}");
  }
}
  /// Helper untuk mengecek apakah sebuah file adalah gambar
  bool _isImage(File file) {
    final path = file.path.toLowerCase();
    return path.endsWith('.jpg') || path.endsWith('.jpeg') || path.endsWith('.png') || path.endsWith('.gif');
  }

  @override
  Widget build(BuildContext context) {
    final pengaduanProvider = context.watch<PengaduansProvider>();
    final uploadProvider = context.watch<UploadMediaProvider>();
    final isLoading = pengaduanProvider.isLoading || uploadProvider.isLoading;

    // Style umum untuk border input field
    OutlineInputBorder pinkBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFFF5A9B8), width: 1.5),
      borderRadius: BorderRadius.circular(8),
    );

    // Fungsi helper untuk dekorasi input agar konsisten
    InputDecoration formDecoration(String label) {
      return InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Colors.grey[600]),
        border: pinkBorder,
        enabledBorder: pinkBorder,
        focusedBorder: pinkBorder,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const TitleCustom(title: "Pengaduan"),
        backgroundColor: Colors.white,
        elevation: 1,
        automaticallyImplyLeading: false, // Sesuaikan jika perlu tombol kembali
      ),
      backgroundColor: Colors.white,
      body: LoadingWidget(
        isLoading: isLoading,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _namaController,
                  decoration: formDecoration('Nama Korban'),
                  validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
                  style: GoogleFonts.poppins(),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _alamatController,
                  decoration: formDecoration('Alamat Lengkap Korban'),
                  validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
                  style: GoogleFonts.poppins(),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<DropdownOption>(
                  value: _selectedKategori,
                  decoration: formDecoration('Jenis Kekerasan'),
                  items: _kategoriOptions.map((option) => DropdownMenuItem<DropdownOption>(
                    value: option,
                    child: Text(option.displayText, style: GoogleFonts.poppins()),
                  )).toList(),
                  onChanged: (value) => setState(() => _selectedKategori = value),
                  validator: (value) => value == null ? 'Pilih kategori kekerasan' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<DropdownOption>(
                  value: _selectedKorban,
                  decoration: formDecoration('Korban'),
                  items: _korbanOptions.map((option) => DropdownMenuItem<DropdownOption>(
                    value: option,
                    child: Text(option.displayText, style: GoogleFonts.poppins()),
                  )).toList(),
                  onChanged: (value) => setState(() => _selectedKorban = value),
                  validator: (value) => value == null ? 'Pilih jenis korban' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _aduanController,
                  decoration: formDecoration('Detail Aduan'),
                  maxLines: 4,
                  validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
                  style: GoogleFonts.poppins(),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _harapanController,
                  decoration: formDecoration('Hasil Yang Diharapkan'),
                  maxLines: 4,
                  validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
                  style: GoogleFonts.poppins(),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(minHeight: 120),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary.withOpacity(0.1), width: 1.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ..._selectedFiles.map((file) {
                          return Stack(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: _isImage(file)
                                      ? Image.file(file, width: 100, height: 100, fit: BoxFit.cover)
                                      : const Icon(Icons.videocam, size: 50, color: Colors.grey),
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () => setState(() => _selectedFiles.remove(file)),
                                  child: Container(
                                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black54),
                                    padding: const EdgeInsets.all(4),
                                    child: const Icon(Icons.close, color: Colors.white, size: 16),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                        GestureDetector(
                          onTap: _pickFiles,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400, style: BorderStyle.none),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey[100],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.add_a_photo_outlined, size: 30, color: Colors.grey),
                                const SizedBox(height: 4),
                                Text("Tambah Bukti", style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: isLoading ? null : _submitPengaduan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    disabledBackgroundColor: Colors.grey.shade300,
                  ),
                  child: Text(
                    'Kirim Pengaduan',
                    style: GoogleFonts.poppins(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}