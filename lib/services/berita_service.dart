import 'dart:convert';
import 'package:http/http.dart' as http;

class BeritaService {
  static const String baseUrl = "https://example.com/api"; // Ganti dengan URL API-mu

  Future<List<String>> fetchBerita() async {
    final response = await http.get(Uri.parse("$baseUrl/berita"));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => item['judul'].toString()).toList();
    } else {
      throw Exception("Gagal mengambil data berita");
    }
  }
}
