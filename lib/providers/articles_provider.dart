import 'package:flutter/material.dart';
import 'package:siappa/providers/auth_provider.dart';
import 'package:siappa/services/articles_service.dart';

import '../models/articles_model.dart';

class ArticlesProvider with ChangeNotifier {
  final ArticlesService _articlesService = ArticlesService();
  List<ArticlesModel> articles = [];
  AuthProvider authProvider = AuthProvider();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _successMessage;
  String? get successMessage => _successMessage;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadAllArticles(AuthProvider authProvider) async {
    if (authProvider.isAuthenticated) {
      _isLoading = true;
      notifyListeners();

      try {
        final token = authProvider.token;
        if (token != null) {
          final response = await _articlesService.fetchAllArticles(token);
          articles =
              response.map((json) => ArticlesModel.fromJson(json)).toList();
        }
      } catch (e) {
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> addArticle({
    required String judul,
    required String isi,
    required String foto,
  }) async {
    _isLoading = true;
    _successMessage = null;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await authProvider.token;

      final message =
          await _articlesService.addArticle(token, judul, isi, foto);
      _successMessage = message;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void resetMessages() {
    _successMessage = null;
    _errorMessage = null;
    notifyListeners();
  }

Future<void> deleteArticle(int id) async {
  _isLoading = true;
  _successMessage = null;
  _errorMessage = null;
  notifyListeners();

  try {
    final token = await authProvider.token;
    final message = await _articlesService.deleteArticle(token, id);
    _successMessage = message;
  } catch (e) {
    _errorMessage = e.toString();
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

}
