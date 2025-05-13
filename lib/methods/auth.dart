import 'package:shared_preferences/shared_preferences.dart';
import 'package:sibadeanmob_v2_fix/helper/database.dart';

class Auth {
  static Future<Map<String, dynamic>> user() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userList = await DatabaseHelper().getUser();
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
