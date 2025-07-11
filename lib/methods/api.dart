import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:sibadeanmob_v2_fix/methods/auth.dart';
import 'package:sibadeanmob_v2_fix/models/SuratKeluar.dart';

class API {
  // === Login User ===2
  final Dio _dio =
      // Dio(BaseOptions(baseUrl: "http://192.168.100.205:8000/api/"));
      Dio(BaseOptions(baseUrl: "https://sibadean.kholzt.com/api/"));
  // final String baseUrl = "https://sibadean.kholzt.com";
  final String baseUrl = "https://sibadean.kholzt.com";

  Future<String?> _getToken() async {
    final user = await Auth.user();
    print(user["token"]);
    return user["token"];
  }

  Future<dynamic> refreshToken(String refreshToken) async {
    try {
      final response = await _dio.post('/auth/refresh', data: {
        'refresh_token': refreshToken,
      });
      return response;
    } on DioException catch (e) {
      return e.response;
    }
  }

  // === Login User ===
  Future<dynamic> loginUser({
    required String nik,
    required String password,
    String? token,
  }) async {
    try {
      // print('NIK: $token');
      /// The new access token should be stored in the user object
      ///
      /// The user object should be updated with the new access token
      final response = await _dio.post(
        'login',
        data: {'nik': nik, 'password': password, "fcm_token": token},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      // print(response.data);
      return response;
    } on DioException catch (e) {
      return e.response;
    }
  }

  Future<dynamic> registerUser({required FormData formData}) async {
    try {
      // print('NIK: $nik');
      final response = await _dio.post('register', data: formData);
      return response;
    } on DioException catch (e) {
      return e.response;
    }
  }

  // === Aktivasi Akun ===
  Future<dynamic> aktivasiAkun({
    required String nik,
    required String email,
    required String nohp,
    required String pass,
  }) async {
    try {
      return await _dio.post(
        "aktivasi",
        data: {"nik": nik, "email": email, "no_hp": nohp, "password": pass},
      );
    } on DioException catch (e) {
      return e.response;
    }
  }

  Future<dynamic> verifikasiNIK({required String nik}) async {
    try {
      return await _dio.post("verifikasi", data: {'nik': nik});
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
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            followRedirects: false, // mencegah Dio mengikuti redirect
            validateStatus: (status) {
              return status != null &&
                  status < 500; // jangan anggap 3xx sebagai error
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
      String? token = await _getToken();
      print(token);
      final response = await _dio.get('dash',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      return response;
    } catch (e) {
      print('Error saat logout: $e');
    }
  }

  Future<dynamic> getdatasurat() async {
    try {
      String? token = await _getToken();

      final response = await _dio.get('surat',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      return response;
    } catch (e) {
      print('Error saat logout: $e');
    }
  }

  Future<dynamic> getdatadetailpengajuansurat({required int idsurat}) async {
    try {
      String? token = await _getToken();

      final response = await _dio.get('detail-pengajuan/$idsurat',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      return response;
    } catch (e) {
      print('Error saat logout: $e');
    }
  }

  Future<dynamic> getberita() async {
    try {
      String? token = await _getToken();

      final response = await _dio.get('berita',
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      return response;
    } catch (e) {
      print('Error saat logout: $e');
    }
  }

  Future<dynamic> getdetailbrita({required int id}) async {
    // print(id);
    try {
      String? token = await _getToken();

      final response = await _dio.get('berita/$id',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          }));
      print(response.data['data']['berita']);
      return response;
    } catch (e) {
      print('Error saat logout: $e');
    }
  }

  // === Aktivasi Akun ===
  Future<dynamic> getRiwayatPengajuan() async {
    try {
      String? token = await _getToken();

      // Mengambil data dari API
      var response = await _dio.get("riwayat-pengajuan",
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      return response;
    } on DioException catch (e) {
      // Menampilkan error jika ada
      if (kDebugMode) {
        debugPrint('Error: ${e.response}');
      }

      return e;
    }
  }

  Future<dynamic> getRiwayatPengajuanMasyarakat() async {
    try {
      String? token = await _getToken();
      print(token);

      // Mengambil data dari API
      var response = await _dio.get("riwayat-pengajuan-masyarakat",
          options: Options(headers: {'Authorization': 'Bearer $token'}));
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
      String? token = await _getToken();

      // Mengambil data dari API
      var response = await _dio.get("riwayat-pengajuan-detail/$idPengajuan",
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      return response;
    } on DioException catch (e) {
      print(e);
      // Menampilkan error jika ada
      if (kDebugMode) {
        debugPrint('Error: ${e.response}');
      }

      return e;
    }
  }

  Future<void> downloadPengajuan(
      {required int idPengajuan, String name = "pengajuan surat.pdf"}) async {
    try {
      final res = await FlutterDownloader.enqueue(
        url: "$baseUrl/api/riwayat-pengajuan/$idPengajuan/download",
        headers: {
          'Authorization': 'Bearer ${await _getToken()}',
        },
        savedDir: "/storage/emulated/0/Download",
        fileName: name,
        showNotification:
            true, // tampilkan notifikasi progress dan selesai otomatis
        openFileFromNotification: true, // buka file jika tap notifikasi selesai
      );
      print(res);
    } catch (e) {
      print(e);
    }
  }

  // Future<dynamic> downloadPengajuan(
  //     {required int idPengajuan, String name = "pengajuan surat.pdf"}) async {
  //   try {
  //     // Tentukan direktori simpan
  //     Directory? downloadDir;
  //     if (Platform.isAndroid) {
  //       downloadDir = Directory(
  //         "/storage/emulated/0/Download",
  //       ); // folder Downloads umum
  //     } else if (Platform.isIOS) {
  //       downloadDir = await getApplicationDocumentsDirectory(); // fallback iOS
  //     }

  //     // Nama file (bisa juga dari API)
  //     String fileName = name;
  //     String savePath = "${downloadDir!.path}/$fileName";

  //     String? token = await _getToken();

  //     // Unduh file
  //     var response = await _dio.download(
  //       "riwayat-pengajuan/$idPengajuan/download",
  //       options: Options(headers: {'Authorization': 'Bearer $token'}),
  //       savePath,
  //       onReceiveProgress: (received, total) {
  //         if (total != -1) {
  //           debugPrint(
  //             "Progress: ${(received / total * 100).toStringAsFixed(0)}%",
  //           );
  //         }
  //       },
  //     );

  //     return true;
  //   } on DioException catch (e) {
  //     debugPrint('Download error: ${e.message}');
  //     return 'Gagal mengunduh file.';
  //   } catch (e) {
  //     debugPrint('Error umum: $e');
  //     return 'Terjadi kesalahan.';
  //   }
  // }

  Future<dynamic> getAnggotaKeluarga({required String nokk}) async {
    try {
      String? token = await _getToken();

      // Mengambil data dari API
      var response = await _dio.get("anggota-keluarga/$nokk",
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      return response;
    } on DioException catch (e) {
      print('Error: $e');

      return e;
    }
  }

  Future<dynamic> chgPass({
    required String nik,
    required String password,
    required String newPass,
    required String confPass,
  }) async {
    try {
      String? token = await _getToken();

      final response = await _dio.post(
        'ubhpass',
        data: {
          'nik': nik,
          'password': password,
          'newPass': newPass,
          'confPass': confPass,
        },
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }),
      );
      return response;
    } on DioException catch (e) {
      return e.response;
    }
  }

  Future<dynamic> chgNoHp({required String nik, required String noHp}) async {
    try {
      String? token = await _getToken();
      final response = await _dio.post(
        'ubhnohp',
        data: {'nik': nik, 'no_hp': noHp},
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }),
      );

      return response;
    } on DioException catch (e) {
      return e.response;
    }
  }

  Future<dynamic> chgEmail({required String nik, required String email}) async {
    try {
      String? token = await _getToken();

      print('NIK: $nik');
      final response = await _dio.post(
        'ubhemail',
        data: {'nik': nik, 'email': email},
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }),
      );

      return response;
    } on DioException catch (e) {
      return e.response;
    }
  }

  Future<dynamic> kirimKeDio({required FormData formData}) async {
    try {
      String? token = await _getToken();

      final response = await _dio.post("ajukan-surat",
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          }),
          data: formData);
      return response;
    } on DioException catch (e) {
      return e.response;
    }
  }

  Future<dynamic> updategambarktp({required FormData formData}) async {
    try {
      String? token = await _getToken();

      final response = await _dio.post("updategambarktp",
          options: Options(headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          }),
          data:
              formData); // Ganti dengan endpoint yang sesuai", data: formData);
      return response;
    } on DioException catch (e) {
      print("Terjadi error saat mengirim data:${e.response?.data}");
    }
  }

  Future<dynamic> updategambarkk({required FormData formData}) async {
    try {
      String? token = await _getToken();

      final response = await _dio.post("updategambarkk",
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          }),
          data: formData);
      return response;
    } on DioException catch (e) {
      return e.response;
    }
  }

  Future<dynamic> profiledata({required String nik}) async {
    try {
      String? token = await _getToken();

      final response = await _dio.get("profile?nik=$nik",
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      return response;
    } on DioException catch (e) {
      print("Terjadi error saat mengirim data: $e");
    }
  }

  Future<dynamic> updateStatusPengajuan(
      {required int idPengajuan,
      required String keterangan,
      required String status}) async {
    try {
      String? token = await _getToken();
      print("keterangan $keterangan");
      final response = await _dio.post(
          "riwayat-pengajuan-masyarakat/$idPengajuan",
          options: Options(headers: {'Authorization': 'Bearer $token'}),
          data: {
            'keterangan': keterangan,
            'status': status,
          });
      return response;
    } catch (e) {
      print("Terjadi error saat mengirim data: $e");
    }
  }

  Future<dynamic> forgotPassword({required String email}) async {
    try {
      final response = await _dio.post(
        'forgot-password', // Ganti dengan endpoint sesuai backend Laravel Anda
        data: {'email': email},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return response;
    } on DioException catch (e) {
      return e.response;
    }
  }

  Future<dynamic> resetPassword({
    required String token,
    required String email,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.post(
        'reset-password', // Ganti dengan endpoint sesuai backend Laravel Anda
        data: {
          'token': token,
          'email': email,
          'password': newPassword,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      return response;
    } on DioException catch (e) {
      return e.response;
    }
  }

  Future<dynamic> verifikasiMasyarakat() async {
    try {
      String? token = await _getToken();
      final response = await _dio.get(
        '/verifikasi', // Ganti dengan endpoint sesuai backend Laravel Anda
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response;
    } on DioException catch (e) {
      return e.response;
    }
  }

  Future<dynamic> updateVerifikasi(
      {required int status, required int idUser}) async {
    try {
      String? token = await _getToken();
      final response = await _dio.post(
        '/verifikasi/$idUser',
        data: {
          'status': status
        }, // Ganti dengan endpoint sesuai backend Laravel Anda
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response;
    } on DioException catch (e) {
      return e.response;
    }
  }

  Future<dynamic> verifikasiDetailMasyarakat({required int idUser}) async {
    try {
      String? token = await _getToken();
      final response = await _dio.get(
        '/verifikasi/$idUser', // Ganti dengan endpoint sesuai backend Laravel Anda
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response;
    } on DioException catch (e) {
      return e.response;
    }
  }

  Future<dynamic> cekuser() async {
    try {
      String? token = await _getToken();
      final response = await _dio.get('cekuser',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          ));
      return response;
    } on DioException catch (e) {
      return e.response;
    }
  }

  Future<dynamic> pengaturan() async {
    try {
      String? token = await _getToken();
      final response = await _dio.get('pengaturan',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          ));
      return response;
    } on DioException catch (e) {
      return e.response;
    }
  }

  Future<dynamic> saveFcmToken(
      {required String token, required int userId}) async {
    try {
      // String? token = await _getToken();
      final response = await _dio.get('fcm/save-token',
          options: Options(
            headers: {
              'Accept': 'application/json',
            },
          ));
      return response;
    } on DioException catch (e) {
      return e.response;
    }
  }

  Future<List<SuratKeluar>> getSuratKeluar() async {
    try {
      final response = await _dio.get('/surat-keluar');

      if (response.statusCode == 200) {
        final List data;
        if (response.data is List) {
          data = response.data;
        } else if (response.data is Map &&
            response.data.containsKey('suratkeluar')) {
          data = response.data['suratkeluar'];
        } else {
          throw Exception('Format response tidak dikenal');
        }
        return data.map((json) => SuratKeluar.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load surat keluar');
      }
    } catch (e) {
      throw Exception('Error fetching surat keluar: $e');
    }
  }

  Future<dynamic> ttd(FormData form) async {
    try {
      String? token = await _getToken();
      final response = await _dio.post('ttdup',
          data: form,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          ));
      return response;
    } on DioException catch (e) {
      return e.response;
    }
  }
}
