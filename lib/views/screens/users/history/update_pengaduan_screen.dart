import 'package:flutter/material.dart';


class EditPengaduanScreen extends StatelessWidget {
  const EditPengaduanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit'),
        backgroundColor: Colors.grey[200],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFF5A9B8)),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Edit foto/video',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFF5A9B8)),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Image(
                            image: AssetImage('assets/kekerasan_seksual.jpg'), // Replace with your asset path
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFF5A9B8)),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: 'Tia Monika Kasandra',
              decoration: const InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFF5A9B8)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: 'Jl. Mawar, Kelurahan Damai',
              decoration: const InputDecoration(
                labelText: 'Alamat',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFF5A9B8)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: 'Kekerasan Seksual',
              decoration: const InputDecoration(
                labelText: 'Jenis Kekerasan',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFF5A9B8)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: 'Anak Perempuan',
              decoration: const InputDecoration(
                labelText: 'Korban',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFF5A9B8)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: 'Tia sering terlhat memar di bagian lengan dan wajah. Setelah ditanya oleh tetangga, Ia mengaku sering dipukul oleh ayahnya ketika melakukan kesalahan kecil. Kejadian ini sudah berulang kali terjadi dan disaksikan oleh warga sekitar.',
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Aduan',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFF5A9B8)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: 'Penanganan hukum terhadap orang tua yang memukul anak-anak.',
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Harapan Korban',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFF5A9B8)),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Navigate back on Cancel
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF5A9B8),
                    minimumSize: const Size(120, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Action for Simpan button
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Data Disimpan')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF5A9B8),
                    minimumSize: const Size(120, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text('Simpan'),
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