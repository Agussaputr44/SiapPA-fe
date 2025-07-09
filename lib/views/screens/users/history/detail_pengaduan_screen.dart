import 'package:flutter/material.dart';


class DetailPengaduanScreen extends StatelessWidget {
  const DetailPengaduanScreen({Key? key}) : super(key: key);

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
        title: const Text('Detail'),
        backgroundColor: Colors.grey[200],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5A9B8),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                children: [
                  const Image(
                    image: AssetImage('assets/kekerasan_seksual.jpg'), // Replace with your asset path
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tia Monika Kasandra',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Action for Diproses button
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
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Jl. Mawar, Kelurahan Damai',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Kekerasan Seksual',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Korban  : Anak Perempuan',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Aduan   : Tia sering terlhat memar di bagian lengan dan wajah. Setelah ditanya oleh tetangga, Ia mengaku sering dipukul oleh okeh ayahnya ketika melakuukan kesalahan kecil. Kejadian ini sudah berulang kali terjadi dan disaksikan oleh warga sekitar.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Harapan Korban: Penanganan hukum terhadap orang tua yang memukul anak-anak.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Action for Edit button
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Edit')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF5A9B8),
                    minimumSize: const Size(120, 40),
                  ),
                  child: const Text('Edit'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Action for Hapus button
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Hapus')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF5A9B8),
                    minimumSize: const Size(120, 40),
                  ),
                  child: const Text('Hapus'),
                ),
              ],
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
}