// TODO Implement this library.
import 'package:http/http.dart' as http;
import 'dart:convert';

class SuratService {
  Future<List<dynamic>> getSuratMasukRT() async {
    final response = await http.get(Uri.parse("https://your-api.com/api/surat/masuk/rt"));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  Future<List<dynamic>> getSuratMasukRW() async {
    final response = await http.get(Uri.parse("https://your-api.com/api/surat/masuk/rw"));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Gagal mengambil data");
    }
  }
}
