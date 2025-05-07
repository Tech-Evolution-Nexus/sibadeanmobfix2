import 'package:intl/intl.dart';
import 'package:sibadeanmob_v2_fix/models/SuratModel.dart';
import 'package:sibadeanmob_v2_fix/models/userModel.dart';

class PengajuanSurat {
  final int id;
  final String nik;
  final int idSurat;
  final String? nomorSurat;
  final String status;
  final String? pengantarRt;
  final String? keterangan;
  final String? keteranganDitolak;
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

  // Fungsi untuk memformat tanggal
  String get formattedCreatedAt {
    try {
      DateTime date = DateTime.parse(createdAt);
      return DateFormat('dd-MM-yyyy')
          .format(date); // Ganti dengan format yang diinginkan
    } catch (e) {
      return createdAt; // Jika terjadi kesalahan, kembalikan tanggal asli
    }
  }

  factory PengajuanSurat.fromJson(Map<String, dynamic> json) {
    DateTime date = DateTime.parse(json["created_at"]);
    String dateFormat = DateFormat('dd/MM/yyyy').format(date);
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
      createdAt: dateFormat ?? '',
    );
  }
}
