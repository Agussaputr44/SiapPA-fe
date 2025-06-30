import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/*
 * This file contains the text styles used throughout the application.
 * It defines primary font styles, headings, body text, and other text styles
 * using Google Fonts for consistency and design.
 */

class AppFonts {
  static final TextStyle primaryFont = GoogleFonts.poppins();
  static final TextStyle heading1 = GoogleFonts.poppins(
    fontSize: 32.0,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
  );

  // static final TextStyle heading2 = GoogleFonts.roboto(
  //   fontSize: 24.0,
  //   fontWeight: FontWeight.w700, // Bold
  //   letterSpacing: 0.25,
  //   color: AppColors.textPrimary,
  // );

  // static final TextStyle body = GoogleFonts.roboto(
  //   fontSize: 16.0,
  //   fontWeight: FontWeight.w400, // Regular
  //   color: AppColors.textSecondary,
  // );

  // static final TextStyle caption = GoogleFonts.roboto(
  //   fontSize: 12.0,
  //   fontWeight: FontWeight.w400, // Regular
  //   color: AppColors.textSecondary,
  // );

  // static final TextStyle button = GoogleFonts.roboto(
  //   fontSize: 16.0,
  //   fontWeight: FontWeight.w500, // Medium
  //   color: AppColors.textOnPrimary,
  // );

  // // Text Style untuk error message
  // static final TextStyle error = GoogleFonts.roboto(
  //   fontSize: 14.0,
  //   fontWeight: FontWeight.w400,
  //   color: AppColors.error,
  // );
}
