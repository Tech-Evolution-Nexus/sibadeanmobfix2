import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/userModel.dart';

class AuthService {
  final String baseUrl = "http://127.0.0.1:8000/api/";
// 🟢 LOGIN
  Future<UserModel?> login(String nik, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"nik": nik, "password": password}),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey("user")) {
          return UserModel.fromJson(responseData["user"]);
        }
      }
      return null;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  // 🟢 REGISTER
  Future<Map<String, dynamic>?> register(Map<String, dynamic> data, String nama) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {"error": "Gagal terhubung ke server"};
    }
  }

  // 🟢 VERIFIKASI NIK
  Future<Map<String, dynamic>?> verifikasiNik(String nik) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/verifikasi"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"nik": nik}),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {"error": "Gagal terhubung ke server"};
    }
  }

  Future<dynamic> aktivasiAkun(String nik, String code) async {
    try {
      var response = await http.post(
        Uri.parse("${baseUrl}aktivasi"),
        body: {
          "nik": nik,
          "code": code, // ✅ Pastikan kode aktivasi dikirim
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {"error": "Gagal menghubungi server."};
    }
  }
}
