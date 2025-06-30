import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'profile_dropdown.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50, right: 20.0, left: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    children: [
                      const TextSpan(text: "Hello "),
                      TextSpan(
                        text: "Mysyryf",
                        style: GoogleFonts.poppins(color: Colors.pink[400]),
                      ),
                    ],
                  ),
                ),
                Text(
                  "Kepedulian Yang utama",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 33,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          const ProfileDropdown(),
        ],
      ),
    );
  }
}