/// Konfigurasi API aplikasi.
///
/// File ini menyimpan konfigurasi endpoint API yang digunakan dalam aplikasi,
/// mencakup base URL, versi API, serta endpoint spesifik untuk autentikasi, upload, artikel, dan pengaduan.
///
/// Fitur utama:
/// - Mendefinisikan base URL, versi API, dan utility untuk membangun endpoint lengkap.
/// - Menyediakan endpoint statis dan method untuk detail endpoint dinamis.
///
/// Contoh penggunaan:
/// ```dart
/// final url = ApiConfig.buildUrl(ApiConfig.login);
/// final artikelUrl = ApiConfig.buildUrl(ApiConfig.artikelDetail("5"));
/// ```
class ApiConfig {
  /// Base URL server backend.
  static const String baseUrl = "https://fancy-quick-lacewing.ngrok-free.app";

  /// Versi API yang digunakan.
  static const String apiVersion = "v1";

  /// Base URL API lengkap.
  static String get baseApiUrl => "$baseUrl/api/$apiVersion";

  /// Base URL untuk resource gambar.

  /// Base URL untuk resource profil (misal: foto profil user).
  static String get baseImageUrlProfile => "$baseUrl/";

  // === Endpoint Auth ===

  /// Endpoint registrasi pengguna.
  static const String register = "/auth/register";

  /// Endpoint login menggunakan Google.
  static const String google = "/auth/google";

  /// Endpoint login.
  static const String login = "/auth/login";

  /// Endpoint logout.
  static const String logout = "/auth/logout";

  /// Endpoint mengambil semua data user.
  static const String getAllUsers = "/auth/users";

  /// Endpoint mengambil data profil user saat ini.
  static const String getUserProfile = "/auth/user";

  static const String updateUserProfile = "/auth/user";


  static const String updatePassword = "/auth/update-password";


  // === Endpoint Upload ===

  /// Endpoint upload file.
  static const String uploadFiles = "/uploads";

  // === Endpoint Artikel ===

  /// Endpoint mengambil daftar artikel.
  static const String articles = "/artikels";

  /// Endpoint detail artikel berdasarkan [id].
  static String artikelDetail(int id) => "/artikels/$id";
  static String artikelUpdate(int id) => "/artikels/$id";


  static String artikelDelete(int id) => "/artikels/$id";



  // === Endpoint Pengaduan ===

  /// Endpoint mengambil daftar pengaduan.
  static const String pengaduans = "/pengaduans";

  /// Endpoint detail pengaduan berdasarkan [id].
  static String pengaduanDetail(String id) => "/pengaduans/$id";

  /// Utility untuk membangun full URL dari endpoint.
  ///
  /// Contoh:
  /// ```dart
  /// final url = ApiConfig.buildUrl(ApiConfig.login);
  /// ```
  static String buildUrl(String endpoint) => "$baseApiUrl$endpoint";
}