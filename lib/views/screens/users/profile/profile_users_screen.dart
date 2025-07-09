import 'package:flutter/material.dart';
import 'package:siappa/views/widgets/tittle_custom_widget.dart';

class ProfileUsersScreen extends StatelessWidget {
  const ProfileUsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TitleCustom(title: "Profile"),
        automaticallyImplyLeading: false,
      ),
    );
  }
}
