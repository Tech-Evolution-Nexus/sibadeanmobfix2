import 'package:sibadeanmob_v2_fix/models/MasyarakatModel.dart';

class AuthUserModel {
  final int id;
  final String role;
  final String nama_lengkap;
  final String email;
  final String access_token;
  final String nik;
  final String no_kk;
  final String avatar;

  AuthUserModel({
    required this.id,
    required this.nama_lengkap,
    required this.email,
    required this.access_token,
    required this.role,
    required this.nik,
    required this.no_kk,
    this.avatar = '',
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['id'],
      role: json['role'],
      email: json['email'],
      nama_lengkap: json['masyarakat']['nama_lengkap'],
      nik: json['masyarakat']['nik'],
      no_kk: json['masyarakat']['no_kk'],
      access_token: json['access_token'] ?? '',
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'email': email,
      'nama_lengkap': nama_lengkap,
      'nik': nik,
      'no_kk': no_kk,
      'access_token': access_token,
      'avatar': avatar,
    };
  }
}
