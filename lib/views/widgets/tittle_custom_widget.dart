import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleCustom extends StatelessWidget {
  final String title;

  const TitleCustom({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Text(title,
          style: GoogleFonts.roboto(
            fontSize: 32.0,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: Colors.pink,
          )),
    );
  }
}
