import 'package:flutter/material.dart';

import '../../utils/app_fonts.dart';

/* * This file contains the TitleCustom widget which is a stateless widget
 * that displays a custom title in the app bar with specific styling.
 * It uses AppFonts for consistent text styling.
 */
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
      title: Text(
        title,
        style: AppFonts.heading1,
      ),
    );
  }
}
