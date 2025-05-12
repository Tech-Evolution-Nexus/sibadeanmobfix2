import 'package:sibadeanmob_v2_fix/models/MasyarakatModel.dart';

class AuthUserModel {
  final int id;
  final String role;
  final String name;
  final String email;
  final String token;
  final String nik;
  final String noKk;
  final String foto;


  AuthUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
    required this.role,
    required this.nik,
    required this.noKk,
    this.foto = '',
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['user']['id'] ?? 0,
      name: json['user']['name'] ?? '',
      email: json['user']['email'] ?? '',
      token: json['token'] ?? '',
      role: json['user']['role'] ?? '',
      nik: json['user']['masyarakat']['nik'] ?? '',
      noKk: json['user']['masyarakat']['no_kk'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'email': email,
      'nama_lengkap': name,
      'nik': nik,
      'no_kk': noKk,
      'token': token,
    };
  }
}
