import 'dart:convert';
import '../configs/api_config.dart';
import 'package:http/http.dart' as http;

class PengaduansService {
  Future<String> addPengaduan({
    required String? token,
    required String namaKorban,
    required String alamat,
    required String aduan,
    required String kategoriKekerasan,
    required String korban,
    required String harapan,
    String? status,
    List<String>? evidencePaths,
  }) async {
    final url = Uri.parse(ApiConfig.buildUrl(ApiConfig.pengaduans));

    final payload = {
      'namaKorban': namaKorban,
      'alamat': alamat,
      'aduan': aduan,
      'kategoriKekerasan': kategoriKekerasan,
      'korban': korban,
      'harapan': harapan,
      if (status != null) 'status': status,
      if (evidencePaths != null) 'evidencePaths': evidencePaths,
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['message'] ?? 'Pengaduan berhasil ditambahkan.';
    } else {
      String message = 'Pengaduan gagal ditambahkan';
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

  Future<List<dynamic>> fetchAllPengaduans(String token) async {
    final url = Uri.parse(ApiConfig.buildUrl(ApiConfig.pengaduans));

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(
          'Gagal memuat data: ${errorData['error'] ?? response.body}');
    }
  }

  Future<List<dynamic>> fetchMyPengaduans(String token) async {
    final url = Uri.parse(ApiConfig.buildUrl("${ApiConfig.my_pengaduans}"));

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(
          'Gagal memuat data: ${errorData['error'] ?? response.body}');
    }
  }

   Future<String> deletePengaduan(String? token, int? id) async {
    final url = Uri.parse(ApiConfig.buildUrl(ApiConfig.pengaduanDelete(id)));
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['message'] ?? 'Berhasil dihapus';
    } else {
      throw Exception('Gagal menghapus pengaduan: ${response.reasonPhrase}');
    }
  }

Future<void> updatePengaduan({
  String? token,
  required String id,
  required String namaKorban,
  required String alamat,
  required String aduan,
  required String kategoriKekerasan,
  required String korban,
  required String harapan,
  required List<String> evidencePaths,
}) async {
  int? parsedId = int.tryParse(id);
  final url = Uri.parse(ApiConfig.buildUrl(ApiConfig.pengaduanUpdate(parsedId)));

  print('Request URL for update: $url'); // Add this line
  print("ini token $token"); // This is already good

  final response = await http.put(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    },
    body: jsonEncode({
      'namaKorban': namaKorban,
      'alamat': alamat,
      'aduan': aduan,
      'kategoriKekerasan': kategoriKekerasan,
      'korban': korban,
      'harapan': harapan,
      'evidencePaths': evidencePaths,
    }),
  );

  print('Response status: ${response.statusCode}');
  print('Response headers: ${response.headers}');
  print('Response body: ${response.body}');
  if (response.statusCode == 302) {
    print('Redirect location: ${response.headers['location']}');
  }
  if (response.statusCode != 200 && response.statusCode != 204) {
    throw Exception('Failed to update pengaduan: ${response.statusCode}');
  }
}}
