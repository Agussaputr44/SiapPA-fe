import 'package:flutter/material.dart';

import '../../utils/app_fonts.dart';

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
