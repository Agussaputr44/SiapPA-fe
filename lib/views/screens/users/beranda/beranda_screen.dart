import 'package:flutter/material.dart';
import 'package:siappa/views/widgets/custom_navbar_bottom.dart';


class BerandaScreen extends StatelessWidget {
  const BerandaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF5A9B8),
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(20.0)),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.home,
                    size: 40,
                    color: Colors.white,
                  ),
                  const Text(
                    'Home',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage(
                    'assets/images/logo.png'), // Replace with your asset path
                height: 100,
              ),
              const SizedBox(height: 16),
              const Text(
                'Lindungi Merepuan dan anak Jadiilah Pelapor\nYang Memutus Mata Rantai Kekerasan Terhadap\nPerempuan Dan Anak',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.person, size: 40, color: Color(0xFFF5A9B8)),
                  SizedBox(width: 16),
                  Icon(Icons.favorite, size: 40, color: Color(0xFFF5A9B8)),
                  SizedBox(width: 16),
                  Icon(Icons.handshake, size: 40, color: Color(0xFFF5A9B8)),
                  SizedBox(width: 16),
                  Icon(Icons.group, size: 40, color: Color(0xFFF5A9B8)),
                  SizedBox(width: 16),
                  Icon(Icons.money, size: 40, color: Color(0xFFF5A9B8)),
                ],
              ),
              const SizedBox(height: 32),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
            ],
          ),
        ),
        bottomNavigationBar: NavBottom());
  }
}
