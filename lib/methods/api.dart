import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class API {
  // === Login User ===2
  final Dio _dio = Dio(BaseOptions(baseUrl: "http://192.168.1.2:8000/api/"));
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

  Future<dynamic> getdatadashboard() async {
    try {
      final response = await _dio.get('dash');
      return response;
    } catch (e) {
      print('Error saat logout: $e');
    }
  }

  Future<dynamic> getdatasurat() async {
    try {
      final response = await _dio.get('surat');
      return response;
    } catch (e) {
      print('Error saat logout: $e');
    }
  }

  Future<dynamic> getdatadetailpengajuansurat({required int idsurat}) async {
    try {
      final response = await _dio.get('detail-pengajuan/$idsurat');
      return response;
    } catch (e) {
      print('Error saat logout: $e');
    }
  }

  Future<dynamic> getberita() async {
    try {
      final response = await _dio.get('berita');
      return response;
    } catch (e) {
      print('Error saat logout: $e');
    }
  }

  Future<dynamic> getdetailbrita({required int id}) async {
    // print(id);
    try {
      final response = await _dio.get('berita/$id');
      print(response.data['data']['berita']);
      return response;
    } catch (e) {
      print('Error saat logout: $e');
    }
  }

  // === Aktivasi Akun ===
  Future<dynamic> getRiwayatPengajuan({required String nik}) async {
    try {
      // Mengambil data dari API
      var response = await _dio.get(
        "riwayat-pengajuan/$nik",
      );

      return response;
    } on DioException catch (e) {
      // Menampilkan error jika ada
      if (kDebugMode) {
        debugPrint('Error: ${e.response}');
      }

      return e;
    }
  }

  Future<dynamic> getRiwayatPengajuanDetail({required int idPengajuan}) async {
    try {
      // Mengambil data dari API
      var response = await _dio.get(
        "riwayat-pengajuan-detail/$idPengajuan",
      );

      return response;
    } on DioException catch (e) {
      // Menampilkan error jika ada
      if (kDebugMode) {
        debugPrint('Error: ${e.response}');
      }

      return e;
    }
  }

  Future<dynamic> getAnggotaKeluarga({required String nokk}) async {
    try {
      final response = await _dio.get("anggota-keluarga/$nokk");
      return response;
    } on DioException catch (e) {
      print('Dio Error: ${e.response?.statusCode} - ${e.message}');
      throw e; // ⬅ ini penting, bukan return e
    }
  }

  Future<dynamic> chgPass(
      {required String nik,
      required String password,
      required String newPass,
      required String confPass}) async {
    try {
      print('NIK: $nik');
      final response = await _dio.post(
        'ubhPass',
        data: {
          'nik': nik,
          'password': password,
          'new_password': newPass,
          'confirm_password': confPass,
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

  Future<dynamic> chgNoHp({required String nik, required String noHp}) async {
    try {
      print('NIK: $nik');
      final response = await _dio.post(
        'ubhNoHp',
        data: {
          'nik': nik,
          'no_kitap': noHp,
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

  Future<dynamic> chgEmail({required String nik, required String email}) async {
    try {
      print('NIK: $nik');
      final response = await _dio.post(
        'ubhemail',
        data: {
          'nik': nik,
          'email': email,
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
}
