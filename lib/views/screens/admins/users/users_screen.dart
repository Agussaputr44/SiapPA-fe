import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siappa/views/screens/admins/users/users_card_widget.dart';
import 'package:siappa/views/screens/admins/widgets/app_bar_widget.dart';
import 'package:siappa/views/widgets/loading_widget.dart';

import '../../../../providers/users_provider.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<UsersProvider>().isLoading;
    final usersProvider = context.watch<UsersProvider>();

    return LoadingWidget(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBarWidget(
          title: "Pengguna",
          onBack: () => Navigator.of(context).pop(),
          subtitle:
              'Sistem Informasi Aduan dan Perlindungan Perempuan dan Anak',
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: usersProvider.allUsers.isEmpty
              ? const Center(child: Text("Tidak ada data pengguna."))
              : ListView.builder(
                  itemCount: usersProvider.allUsers.length,
                  itemBuilder: (context, index) {
                    final user = usersProvider.allUsers[index];
                    return UsersCardWidget(user: user);
                  },
                ),
        ),
      ),
    );
  }
}
