import '../configs/api_config.dart';



String getFotoUrl(String? fotoProfile) {
  if (fotoProfile == null || fotoProfile.isEmpty) {
    return "";
  }
  if (fotoProfile.startsWith("http")) {
    return fotoProfile;
  } else {
    return "${ApiConfig.baseUrl}$fotoProfile";
  }
}
