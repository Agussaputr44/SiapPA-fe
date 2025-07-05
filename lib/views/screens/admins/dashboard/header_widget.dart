import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:siappa/providers/users_provider.dart';
import 'package:siappa/utils/app_size.dart';
import 'profile_dropdown.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = AppSize.appWidth;

    // Tentukan fontSize berdasarkan lebar layar
    double greetingFontSize = screenWidth * 0.06;   // ~24 pada 400px
    double subtitleFontSize = screenWidth * 0.08;   // ~33 pada 400px

    return Padding(
      padding: EdgeInsets.only(
        top: screenWidth * 0.05, 
        right: screenWidth * 0.02,
        left: screenWidth * 0.02,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Consumer<UsersProvider>(
              builder: (context, usersProvider, child) {
                // final user = usersProvider.user;
                // final userName = user?.name ?? "Admin";
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          fontSize: greetingFontSize.clamp(15, 22),
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        children: [
                          const TextSpan(text: "Hello, "),
                          TextSpan(
                            text: "Admin",
                            style: GoogleFonts.poppins(
                              color: Colors.pink[400],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Kepedulian Yang utama",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: subtitleFontSize.clamp(22, 28),
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const ProfileDropdown(),
        ],
      ),
    );
  }
}
