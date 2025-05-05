import 'package:sibadeanmob_v2_fix/models/SuratModel.dart';
import 'package:sibadeanmob_v2_fix/models/userModel.dart';

class PengajuanSurat {
  final String id;
  final String nik;
  final String idSurat;
  final String nomorSurat;
  final String status;
  final String pengantarRt;
  final String keterangan;
  final String keteranganDitolak;
  final MasyarakatModel masyarakat;
  final Surat surat;
  final String createdAt;

  PengajuanSurat({
    required this.id,
    required this.nik,
    required this.idSurat,
    required this.nomorSurat,
    required this.status,
    required this.pengantarRt,
    required this.keterangan,
    required this.keteranganDitolak,
    required this.masyarakat,
    required this.surat,
    required this.createdAt,
  });

  factory PengajuanSurat.fromJson(Map<String, dynamic> json) {
    return PengajuanSurat(
      id: json['id'] ?? '',
      nik: json['nik'] ?? '',
      idSurat: json['id_surat'] ?? '',
      nomorSurat: json['nomor_surat'] ?? '',
      status: json['status'] ?? '',
      pengantarRt: json['pengantar_rt'] ?? '',
      keterangan: json['keterangan'] ?? '',
      keteranganDitolak: json['keterangan_ditolak'] ?? '',  
      masyarakat: MasyarakatModel.fromJson(json["masyarakat"]),
      surat: Surat.fromJson(json["surat"]),
      createdAt: json['created_at'] ?? '',
    );
  }
}
