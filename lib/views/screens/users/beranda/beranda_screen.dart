import 'package:flutter/material.dart';

import '../../../../utils/app_colors.dart';
import '../../../widgets/tittle_custom_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TitleCustom(title: "Beranda"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 0),
                child: Image.asset(
                  "assets/images/logo.png",
                  height: 100,
                  width: 130,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: const Text(
                  'Panda (Pusat Aduan Anak Dan Perempuan) adalah sebuah aplikasi yang berguna untuk melakukan pengaduan kepada UPT PPA Kabupaten Bengkalis.',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    overflow: TextOverflow.clip
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 0),
                child: Image.asset(
                  "assets/images/logo.png",
                  height: 300,
                  width: 300,
                ),
              ),
              Container(
                margin: const EdgeInsets.all(30),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '“ Lindungi Perempuan dan Anak. Jadilah Pelopor Yang Memutus Mata Rantai Kekerasan Terhadap Perempuan Dan Anak ”',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
