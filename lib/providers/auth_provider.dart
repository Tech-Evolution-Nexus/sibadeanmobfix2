import 'package:flutter/material.dart';
import '../models/AuthUserModel.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _errorMessage;
  AuthUserModel? _user;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AuthUserModel? get user => _user;

  // 🟢 LOGIN
  Future<bool> login(String nik, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    AuthUserModel? response = await _authService.login(nik, password);
    
    _isLoading = false;

    if (response != null) {
      _user = response;
      notifyListeners();
      return true;
    } else {
      _errorMessage = "Login gagal, periksa NIK dan password";
      notifyListeners();
      return false;
    }
  }

  // 🟢 REGISTER
  
  // 🟢 VERIFIKASI NIK
  Future<bool> verifikasiNik(String nik) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    var response = await _authService.verifikasiNik(nik);
    
    _isLoading = false;

    if (response != null && response.containsKey("message")) {
      return true;
    } else {
      _errorMessage = response?["error"] ?? "Terjadi kesalahan";
      notifyListeners();
      return false;
    }
  }

  // 🟢 AKTIVASI AKUN
Future<bool> aktivasiAkun(String nik, String code) async {
  _isLoading = true;
  _errorMessage = null;
  notifyListeners();

  var response = await _authService.aktivasiAkun(nik, code); // ✅ Kirim NIK & kode aktivasi

  _isLoading = false;

  if (response != null && response.containsKey("message")) {
    return true;
  } else {
    _errorMessage = response?["error"] ?? "Terjadi kesalahan";
    notifyListeners();
    return false;
  }
}
}
