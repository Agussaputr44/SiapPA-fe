import 'dart:io';
import 'package:flutter/material.dart';
import 'package:siappa/providers/auth_provider.dart';
import '../services/upload_media_service.dart';

class UploadMediaProvider with ChangeNotifier {
  final UploadMediaService _uploadService = UploadMediaService();
  AuthProvider authProvider = AuthProvider();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<String> _uploadedFiles = [];
  List<String> get uploadedFiles => _uploadedFiles;

  String? _error;
  String? get error => _error;

  Future<void> upload(List<File> files) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final token = await authProvider.token;
      final result =
          await _uploadService.uploadFiles(token: token, files: files);
      _uploadedFiles = result;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _uploadedFiles = [];
    _error = null;
    notifyListeners();
  }
}
