import 'package:flutter/material.dart';
import 'package:siappa/providers/auth_provider.dart';
import 'package:siappa/services/articles_service.dart';

import '../models/articles_model.dart';

class ArticlesProvider with ChangeNotifier {
  final ArticlesService _artikelsService = ArticlesService();
  List<ArticlesModel> articles = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadAllArticles(AuthProvider authProvider) async {
    print("load articles");
    if (authProvider.isAuthenticated) {
      _isLoading = true;
      notifyListeners();

      try {
        final token = await authProvider.token;
        if (token != null) {
          final response = await _artikelsService.fetchAllArticles(token);

          // Ubah list dynamic menjadi List<ArticlesModel>
          articles =
              response.map((json) => ArticlesModel.fromJson(json)).toList();
        }
      } catch (e) {
        print('Error loading artikels: $e');
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }
}
