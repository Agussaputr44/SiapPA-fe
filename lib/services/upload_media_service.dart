import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../configs/api_config.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class UploadMediaService {
  /// Upload multiple media files to Laravel backend
  Future<List<String>> uploadFiles({
    required String token,
    required List<File> files,
  }) async {
    final url = Uri.parse(ApiConfig.buildUrl(ApiConfig.uploadFiles)); // pastikan ini sesuai
    final request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $token';

    for (File file in files) {
      final mimeType = lookupMimeType(file.path)?.split('/');
      if (mimeType == null || mimeType.length != 2) {
        throw Exception('Unsupported file type');
      }

      request.files.add(await http.MultipartFile.fromPath(
        'files[]',
        file.path,
        contentType: MediaType(mimeType[0], mimeType[1]),
      ));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['files'] is List) {
        return List<String>.from(data['files']);
      } else {
        throw Exception('Response format tidak sesuai');
      }
    } else {
      String message = 'Upload gagal';
      try {
        final errorData = jsonDecode(response.body);
        if (errorData is Map && errorData.containsKey('message')) {
          message += ': ${errorData['message']}';
        } else if (errorData is Map) {
          message += ': ${errorData.values.join(', ')}';
        } else {
          message += ': ${response.body}';
        }
      } catch (_) {
        message += ': ${response.body}';
      }
      throw Exception(message);
    }
  }
}
