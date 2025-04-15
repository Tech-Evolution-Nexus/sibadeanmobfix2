import 'package:http/http.dart' as http;
import 'dart:convert';

class RTRWService {
  final String baseUrl = "https://example.com/api";

  Future<List<dynamic>> getSuratMasuk() async {
    final response = await http.get(Uri.parse('$baseUrl/rt-rw/surat-masuk'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Gagal mengambil surat masuk");
    }
  }

  Future<bool> accPengajuan(String idSurat) async {
    final response = await http.post(
      Uri.parse('$baseUrl/rt-rw/acc-surat/$idSurat'),
      headers: {"Content-Type": "application/json"},
    );

    return response.statusCode == 200;
  }
}
