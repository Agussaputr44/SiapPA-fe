import 'package:flutter/material.dart';


class DetailArticleScreen extends StatelessWidget {
  const DetailArticleScreen({Key? key}) : super(key: key);

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
        title: const Text('Artikel'),
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
                    image: AssetImage('assets/kekerasan_fisik.jpg'), // Replace with your asset path
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Kekerasan Fisik',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          '♦ Menyebabuh bagan tubuh tanpa persetujuan',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          '♦ Mengrim gamabar yang tidak seharusnya',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          '♦ Memaksakan melakukann hubungan seksual',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          '♦ Memperlihatkan hal yang negatif di hadapan orang banyak',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Merenadahka',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tindakan yang dilakukan seseorang terhadap Orang lain dengan menggunakan unsur paks aan, ancaman, atau memanipulasi untuk melakuakn aktivitas seksual tanpa ada kata persetujuan. Kekerasan ini dapat menyebab kan trauma, rasa takut, malu, bahkan gangguan psikologi jangka panjang.',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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