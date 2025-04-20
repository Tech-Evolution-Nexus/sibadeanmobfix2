import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class API {
  // === Login User ===
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8000/api/'));
  Future<String?> _getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('token');
  }

  // === Login User ===
  Future<dynamic> loginUser(
      {required String nik, required String password}) async {
    try {
      print('NIK: $nik');
      final response = await _dio.post(
        'login',
        data: {
          'nik': nik,
          'password': password,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      return response;
    } on DioException catch (e) {
      return e.response;
    }
  }

  Future<dynamic> registerUser({
    required String fullName,
    required String nik,
    required String noKk,
    required String tempatLahir,
    required String tanggalLahir,
    required String jenisKelamin,
    required String alamat,
    required String pekerjaan,
    required String agama,
    required String phone,
    required String email,
    required String password,
    required dynamic kkGambar, // File (Android/iOS) atau Uint8List (Web)
  }) async {
    FormData formData = FormData.fromMap({
      "nama_lengkap": fullName,
      "nik": nik,
      "no_kk": noKk,
      "tempat_lahir": tempatLahir,
      "tanggal_lahir": tanggalLahir,
      "jenis_kelamin": jenisKelamin,
      "alamat": alamat,
      "pekerjaan": pekerjaan,
      "agama": agama,
      "phone": phone,
      "email": email,
      "password": password,
    });

    // Add KK image file
    if (!kIsWeb) {
      if (kkGambar is File && kkGambar.existsSync()) {
        formData.files.add(MapEntry(
          "kk_gambar",
          await MultipartFile.fromFile(
            kkGambar.path,
            // filename: basename(kkGambar.path),
          ),
        ));
      }
    } else {
      if (kkGambar != null) {
        formData.files.add(MapEntry(
          "kk_gambar",
          MultipartFile.fromBytes(
            kkGambar,
            filename: "kk_gambar.jpg",
          ),
        ));
      }
    }

    return await _dio.post('register', data: formData);
  }

  // === Aktivasi Akun ===
  Future<dynamic> aktivasiAkun(
      {required String nik,
      required String email,
      required String pass}) async {
    try {
      return await _dio.post(
        "aktivasi",
        data: {
          "nik": nik,
          "email": email,
          "password": pass,
        },
      );
    } on DioException catch (e) {
      return e.response;
    }
  }

  Future<dynamic> verifikasiNIK({required String nik}) async {
    try {
      return await _dio.post(
        "verifikasi",
        data: {
          'nik': nik,
        },
      );
    } on DioException catch (e) {
      return e.response;
    }
  }

  Future<dynamic> logout() async {
    try {
      // Ambil token yang ada di SharedPreferences
      String? token = await _getToken();

      if (token != null) {
        final response = await _dio.post(
          'logout',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        return response;
      } else {
        print('Tidak ada token yang tersimpan');
      }
    } catch (e) {
      print('Error saat logout: $e');
    }
  }
}
