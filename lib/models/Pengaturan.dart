import 'dart:convert';
import 'package:sibadeanmob_v2_fix/methods/api.dart';
import 'package:http/http.dart' as http;

class Pengaturan {
  final int id;
  final String descApk;
  final String appName;
  final int hasRw;
  final String primaryColor;
  final String secondaryColor;
  final String tandaTangan;
  final String logoHorizontal;
  final String logo;
  final String kelurahan;
  final String kodePos;
  final String kabupaten;
  final String kecamatan;
  final String provinsi;

  Pengaturan({
    required this.id,
    required this.descApk,
    required this.appName,
    required this.hasRw,
    required this.primaryColor,
    required this.secondaryColor,
    required this.tandaTangan,
    required this.logoHorizontal,
    required this.logo,
    required this.kelurahan,
    required this.kodePos,
    required this.kabupaten,
    required this.kecamatan,
    required this.provinsi,
  });

  factory Pengaturan.fromJson(Map<String, dynamic> json) {
    return Pengaturan(
      id: json['id'] ?? 0,
      hasRw: json['hasRw'] ?? false,
      descApk: json['descApk'] ?? '',
      appName: json['appName'] ?? '',
      primaryColor: json['primary_color'] ?? '',
      secondaryColor: json['secondary_color'] ?? '',
      tandaTangan: json['tanda_tangan'] ?? '',
      logoHorizontal: json['logo_horizontal'] ?? '',
      logo: json['logo'] ?? '',
      kelurahan: json['kelurahan'] ?? '',
      kodePos: json['kode_pos'] ?? '',
      kabupaten: json['kabupaten'] ?? '',
      kecamatan: json['kecamatan'] ?? '',
      provinsi: json['provinsi'] ?? '',
    );
  }

  static Future<Pengaturan> getPengaturan() async {
    try {
      final response = await API().pengaturan();
      final data = response.data["data"];
      Pengaturan p = Pengaturan.fromJson(data);
      return p;
    } catch (e) {
      throw Exception('Gagal memuat data surat: $e');
    }
  }
}
