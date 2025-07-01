import 'package:flutter/material.dart';
import 'package:siappa/models/users_model.dart';
import 'package:siappa/providers/auth_provider.dart';
import 'package:siappa/services/users_service.dart';

class UsersProvider with ChangeNotifier {
  final UsersService usersService = UsersService();
  UsersModel? user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadUserDetails(AuthProvider authProvider) async {
    print("Loading user details...");
    if (authProvider.isAuthenticated) {
      _isLoading = true;
      notifyListeners();

      try {
        final token = await authProvider.token;
        if (token != null) {
          final userData = await usersService.fetchUserDetail(token);
          user = UsersModel.fromJson(userData);
          print("User data loaded: ${user?.email}");
        }
      } catch (e) {
        // Optionally handle error
        print('Error loading user details: $e');
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }
}