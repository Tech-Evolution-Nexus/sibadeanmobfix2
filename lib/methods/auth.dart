import 'package:shared_preferences/shared_preferences.dart';
import 'package:sibadeanmob_v2_fix/models/userModel.dart';

class Auth {
  static Future<Map<String, dynamic>> user() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'user_id': prefs.getInt('user_id'),
      'role': prefs.getString('role'),
      'nama': prefs.getString('nama'),
      'nik': prefs.getString('nik'),
      'noKK': prefs.getString('noKK'),
      'token': prefs.getString('token'),
      'noKk': prefs.getString('noKK'),
    };
  }
}
