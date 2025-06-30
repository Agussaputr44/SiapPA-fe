import 'package:flutter/material.dart';
import 'package:siappa/views/screens/admins/widgets/app_bar_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class AddArticleScreen extends StatelessWidget {
  const AddArticleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder pinkBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFFF48FB1), width: 1.5),
      borderRadius: BorderRadius.circular(8),
    );

    return Scaffold(
      appBar: AppBarWidget(
        title: "Tambah Artikel",
        subtitle: "Sistem Informasi Aduan dan Perlindungan Perempuan dan Anak",
        onBack: () => Navigator.of(context).pop(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Nama Artikel
              TextField(
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
              // Konten Artikel
              TextField(
                style: GoogleFonts.poppins(),
                maxLines: 12,
                decoration: InputDecoration(
                  hintText: 'Text',
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
              // Upload foto/video
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
                      "Uploud foto/vidio",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Center(
                      child: Icon(
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
                          onPressed: () {
                            // Logic untuk pilih file
                          },
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
              // Tombol Batal dan Simpan
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
                        onPressed: () {
                          // Logic untuk simpan artikel
                        },
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
      backgroundColor: Colors.white,
    );
  }
}