import 'package:flutter/material.dart';

class HistoryPengaduanScreen extends StatelessWidget {
  const HistoryPengaduanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('History Pengaduan'),
        backgroundColor: Colors.grey[200],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildHistoryEntry(
              context,
              imagePath: 'assets/kekerasan_seksual.jpg',
              name: 'Tia Monika Kasandra',
              address: 'Jl. Mawar, Kelurahan Damai',
              violenceType: 'Kekerasan Seksual',
              victim: 'Anak Perempuan',
              complaint: 'Tia sering terlihat memar di bagian lengan dan wajah. Setelah ditanya oleh tetangga, Ia mengaku sering dipukul oleh ayahnya ketika melakukan kesalahan kecil. Kejadian ini sudah berulang kali terjadi dan disaksikan oleh warga sekitar.',
              hope: 'Penanganan hukum terhadap orang tua yang memukul anak-anak.',
              isProcessed: true,
            ),
            const SizedBox(height: 16),
            _buildHistoryEntry(
              context,
              imagePath: 'assets/kekerasan_fisik.jpg',
              name: 'Rina Sari',
              address: 'Jl. Melati, Kelurahan Sejahtera',
              violenceType: 'Kekerasan Fisik',
              victim: 'Wanita Dewasa',
              complaint: 'Rina melaporkan bahwa ia sering mendapatkan kekerasan fisik dari pasangannya. Hal ini terjadi berulang kali di rumah.',
              hope: 'Perlindungan hukum dan konseling untuk korban.',
              isProcessed: false,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: const Color(0xFFF5A9B8),
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Icon(Icons.home, size: 30, color: Colors.white),
            Icon(Icons.add, size: 30, color: Colors.white),
            Icon(Icons.access_time, size: 30, color: Colors.white),
            Icon(Icons.person, size: 30, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryEntry(BuildContext context,
      {required String imagePath,
      required String name,
      required String address,
      required String violenceType,
      required String victim,
      required String complaint,
      required String hope,
      required bool isProcessed}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5A9B8),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        children: [
          const Image(
            image: AssetImage('assets/placeholder.jpg'), // Replace with actual image path
            height: 200,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (isProcessed)
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Diproses')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Diproses'),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  address,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  violenceType,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Korban  : $victim',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  'Aduan   : $complaint',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  'Harapan Korban: $hope',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Edit')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF5A9B8).withOpacity(0.8),
                        minimumSize: const Size(120, 40),
                      ),
                      child: const Text('Edit'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Hapus')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF5A9B8).withOpacity(0.8),
                        minimumSize: const Size(120, 40),
                      ),
                      child: const Text('Hapus'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}