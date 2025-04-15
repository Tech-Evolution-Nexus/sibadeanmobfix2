import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PengajuanService {
  final Dio _dio = Dio();
  final String baseUrl = "https://your-api-url.com/api"; // Ganti dengan URL API Laravel

  Future<Map<String, dynamic>> ajukanSurat({
    required String nama,
    required String nik,
    required String alamat,
    required String keterangan,
    required File fileKK,
    required String jenisSurat,
  }) async {
    try {
      // Ambil token auth jika ada
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      // Buat form data untuk dikirim ke API
      FormData formData = FormData.fromMap({
        "nama": nama,
        "nik": nik,
        "alamat": alamat,
        "keterangan": keterangan,
        "jenis_surat": jenisSurat,
        "file_kk": await MultipartFile.fromFile(fileKK.path, filename: "kk.jpg"),
      });

      // Kirim data ke API Laravel
      Response response = await _dio.post(
        "$baseUrl/pengajuan",
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      return response.data;
    } catch (e) {
      return {"error": e.toString()};
    }
  }
  
}
