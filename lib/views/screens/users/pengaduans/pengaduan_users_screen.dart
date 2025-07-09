import 'package:flutter/material.dart';

import '../../../widgets/tittle_custom_widget.dart';


class PengaduanUsersScreen extends StatelessWidget {
  const PengaduanUsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: const TitleCustom(title: "Pengaduan"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Nama Korban',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFF5A9B8)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Alamat',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFF5A9B8)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Jenis Kekerasan',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFF5A9B8)),
                ),
              ),
              items: <String>['Korban', 'Aduan'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (_) {},
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Korban',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFF5A9B8)),
                ),
              ),
              items: <String>['Korban', 'Aduan'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (_) {},
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Aduan',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFF5A9B8)),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Hasil Yang Diharapkan',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFF5A9B8)),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFF5A9B8)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('Upload foto/video'),
                    const SizedBox(height: 8),
                    const Icon(Icons.cloud_upload, color: Colors.grey),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('Pilih bukti'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Action for Kirim Pengaduan
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pengaduan Terkirim')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF5A9B8),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Kirim Pengaduan',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}