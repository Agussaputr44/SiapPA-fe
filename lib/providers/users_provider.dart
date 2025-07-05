import 'package:flutter/material.dart';
import 'package:siappa/models/users_model.dart';
import 'package:siappa/providers/auth_provider.dart';
import 'package:siappa/services/users_service.dart';

class UsersProvider with ChangeNotifier {
  final UsersService usersService = UsersService();

  UsersModel? user;
  List<UsersModel> allUsers = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Fetch current user detail (based on token)
  Future<void> loadUserDetails(AuthProvider authProvider) async {
    if (!authProvider.isAuthenticated) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = authProvider.token;
      if (token != null) {
        final userData = await usersService.fetchUserDetail(token);
        user = UsersModel.fromJson(userData);
      }
    } catch (e) {
      _errorMessage = "Gagal memuat data pengguna: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch all users (admin use-case)
  Future<void> loadAllUsers(AuthProvider authProvider) async {
    if (!authProvider.isAuthenticated) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = authProvider.token;
      if (token != null) {
        final response = await usersService.fetchAllUsers(token);
        allUsers = response.map((json) => UsersModel.fromJson(json)).toList();
      }
    } catch (e) {
      _errorMessage = "Gagal memuat semua user: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
