import 'package:shared_preferences/shared_preferences.dart';
import 'package:sibadeanmob_v2_fix/helper/database.dart';

class Auth {
  static Future<Map<String, dynamic>> user() async {

    final userList = await DatabaseHelper().getUser();
    if (userList.isEmpty) {
      return {
        'user_id': "",
        'role': "",
        'nama': "",
        'nik': "",
        'noKK': "",
        'token': "",
        'noKk': "",
      }; // map kosong, bukan null
    }
    return {
      'user_id': userList.first.id,
      'role': userList.first.role,
      'nama': userList.first.nama_lengkap,
      'nik': userList.first.nik,
      'noKK': userList.first.no_kk,
      'token': userList.first.access_token,
      'noKk': userList.first.no_kk,
    };
  }
}
