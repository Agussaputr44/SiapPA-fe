import 'package:flutter/material.dart';
import 'package:siappa/models/pengaduans_model.dart';
import 'package:siappa/providers/auth_provider.dart';
import 'package:siappa/services/pengaduans_service.dart';

class PengaduansProvider with ChangeNotifier {
  final PengaduansService _pengaduansService = PengaduansService();

  AuthProvider authProvider = AuthProvider();
  List<PengaduansModel> pengaduans = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _successMessage;
  String? get successMessage => _successMessage;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadAllPengaduans(AuthProvider authProvider) async {
    if (authProvider.isAuthenticated) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      try {
        final token = authProvider.token;
        if (token != null) {
          final response = await _pengaduansService.fetchAllPengaduans(token);

          pengaduans = response.map((json) {
            return PengaduansModel.fromJson(json);
          }).toList();
        }
      } catch (e) {
        _errorMessage = "Terjadi kesalahan saat memuat data: $e";
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }


  Future<void> deleteArticle(int? id) async {
    _isLoading = true;
    _successMessage = null;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await authProvider.token;
      final message = await _pengaduansService.deletePengaduan(token, id);
      _successMessage = message;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<void> addPengaduan({
    required String namaKorban,
    required String alamat,
    required String aduan,
    required String kategoriKekerasan,
    required String korban,
    required String harapan,
    String? status,
    List<String>? evidencePaths,
  }) async {
    _isLoading = true;
    _successMessage = null;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await authProvider.token;

      final message = await _pengaduansService.addPengaduan(
        token: token,
        namaKorban: namaKorban,
        alamat: alamat,
        aduan: aduan,
        kategoriKekerasan: kategoriKekerasan,
        korban: korban,
        harapan: harapan,
        status: status,
        evidencePaths: evidencePaths,
      );
      _successMessage = message;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMyPengaduans(AuthProvider authProvider) async {
    if (authProvider.isAuthenticated) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      try {
        final token = authProvider.token;
        if (token != null) {
          final response = await _pengaduansService.fetchMyPengaduans(token);

          pengaduans = response.map((json) {
            return PengaduansModel.fromJson(json);
          }).toList();
        }
      } catch (e) {
        _errorMessage = "Terjadi kesalahan saat memuat data: $e";
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

 Future<void> updatePengaduan({
  required String id,
  required String namaKorban,
  required String alamat,
  required String aduan,
  required String kategoriKekerasan,
  required String korban,
  required String harapan,
  String? status,
  required List<String> evidencePaths,
}) async {
  _isLoading = true;
  _successMessage = null;
  _errorMessage = null;
  notifyListeners();

  try {
    final token = await authProvider.token;
    if (token == null) {
      throw Exception('Authentication token is missing');
    }

    // Parse id to int if required by PengaduansService
    int? parsedId = int.tryParse(id);
    if (parsedId == null) {
      throw Exception('Invalid pengaduan ID: $id');
    }

    final message = await _pengaduansService.updatePengaduan(
      token: token,
      id: id, // Pass as String to match PengaduansService
      namaKorban: namaKorban,
      alamat: alamat,
      aduan: aduan,
      kategoriKekerasan: kategoriKekerasan,
      korban: korban,
      harapan: harapan,
      // status: status,
      evidencePaths: evidencePaths,
    );
    // _successMessage = message;
  } catch (e) {
    _errorMessage = e.toString();
    debugPrint('Error updating pengaduan: $e');
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}
  
}
