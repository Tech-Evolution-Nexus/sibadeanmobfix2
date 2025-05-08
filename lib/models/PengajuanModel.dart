import 'package:intl/intl.dart';
import 'package:sibadeanmob_v2_fix/models/SuratModel.dart';
import 'package:sibadeanmob_v2_fix/models/userModel.dart';

class PengajuanSurat {
  final int id;
  final String nik;
  final int idSurat;
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
    this.nomorSurat = "-",
    required this.status,
    this.pengantarRt = "-",
    this.keterangan = "-",
    this.keteranganDitolak = "-",
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
      id: json['id'] ?? 0,
      nik: json['nik']?.toString() ?? '-',
      idSurat: json['id_surat'] ?? 0,
      nomorSurat: json['nomor_surat']?.toString() ?? '-',
      status: json['status']?.toString() ?? '-',
      pengantarRt: json['pengantar_rt']?.toString() ?? '-',
      keterangan: json['keterangan']?.toString() ?? '-',
      keteranganDitolak: json['keterangan_ditolak']?.toString() ?? '-',
      masyarakat: MasyarakatModel.fromJson(json["masyarakat"]),
      surat: Surat.fromJson(json["surat"]),
      createdAt: dateFormat ?? '-',
    );
  }
}
