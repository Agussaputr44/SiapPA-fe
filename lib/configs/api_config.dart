
/* * 
 * API Configuration
 * 
 * This file contains the configuration for the API endpoints used in the application.
 * It includes base URLs, versioning, and specific endpoints for authentication, uploads, artikels, and pengaduans.
 */
class ApiConfig {
  // Base URL and API version
  static const String baseUrl = "https://fancy-quick-lacewing.ngrok-free.app";
  static const String apiVersion = "v1";

  // Full base API URL
  static String get baseApiUrl => "$baseUrl/api/$apiVersion";
  static String get baseImageUrl => "$baseUrl/storage/";
  static String get baseImageUrlProfile => "$baseUrl/";

  // === Auth Routes ===
  static const String register = "/auth/register";
  static const String login = "/auth/login";
  static const String logout = "/auth/logout";
  static const String getAllUsers = "/auth/users";
  static const String getUserProfile = "/auth/user";

  // === Uploads ===
  static const String uploadFiles = "/uploads";

  // === Artikels ===
  static const String artikels = "/artikels";
  static String artikelDetail(String id) => "/artikels/$id";

  // === Pengaduans ===
  static const String pengaduans = "/pengaduans";
  static String pengaduanDetail(String id) => "/pengaduans/$id";

  // Utility to build full URL
  static String buildUrl(String endpoint) => "$baseApiUrl$endpoint";
}
