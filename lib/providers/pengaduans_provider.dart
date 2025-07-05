import 'package:flutter/material.dart';
import 'package:siappa/models/pengaduans_model.dart';
import 'package:siappa/providers/auth_provider.dart';
import 'package:siappa/services/pengaduans_service.dart';

class PengaduansProvider with ChangeNotifier {
  final PengaduansService pengaduansService = PengaduansService();

  List<PengaduansModel> pengaduans = [];
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadAllPengaduans(AuthProvider authProvider) async {
    print("loadAllPengaduans() called");
    if (authProvider.isAuthenticated) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      try {
        final token = authProvider.token;
        if (token != null) {
          final response = await pengaduansService.fetchAllPengaduans(token);
          print("Raw response: $response");

          pengaduans = response.map((json) {
            print('json item: $json');
            return PengaduansModel.fromJson(json);
          }).toList();

          print('Parsed pengaduans: $pengaduans');
        }
      } catch (e) {
        _errorMessage = "Terjadi kesalahan saat memuat data: $e";
        print(_errorMessage);
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }
}
