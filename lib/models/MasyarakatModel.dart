import 'package:sibadeanmob_v2_fix/models/userModel.dart';

class MasyarakatModel {
  final String nik;
  final int idUser;
  final String noKk;
  final String namaLengkap;
  final String jenisKelamin;
  final String tempatLahir;
  final String tanggalLahir;
  final String agama;
  final String pendidikan;
  final String pekerjaan;
  final String golonganDarah;
  final String statusPerkawinan;
  final String tanggalPerkawinan;
  final String statusKeluarga;
  final String kewarganegaraan;
  final String noPaspor;
  final String noKitap;
  final String namaAyah;
  final String namaIbu;
  final String createdAt;

  MasyarakatModel({
    required this.nik,
    required this.idUser,
    required this.noKk,
    required this.namaLengkap,
    required this.jenisKelamin,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.agama,
    required this.pendidikan,
    required this.pekerjaan,
    required this.golonganDarah,
    required this.statusPerkawinan,
    required this.tanggalPerkawinan,
    required this.statusKeluarga,
    required this.kewarganegaraan,
    required this.noPaspor,
    required this.noKitap,
    required this.namaAyah,
    required this.namaIbu,
    required this.createdAt,
  });

  factory MasyarakatModel.fromJson(Map<String, dynamic> json) {
    return MasyarakatModel(
      nik: json['nik'] ?? '',
      idUser: json['id_user'] ?? '',
      noKk: json['no_kk'] ?? '',
      namaLengkap: json['nama_lengkap'] ?? '',
      jenisKelamin: json['jenis_kelamin'] ?? '',
      tempatLahir: json['tempat_lahir'] ?? '',
      tanggalLahir: json['tanggal_lahir'] ?? '',
      agama: json['agama'] ?? '',
      pendidikan: json['pendidikan'] ?? '',
      pekerjaan: json['pekerjaan'] ?? '',
      golonganDarah: json['golongan_darah'] ?? '',
      statusPerkawinan: json['status_perkawinan'] ?? '',
      tanggalPerkawinan: json['tanggal_perkawinan'] ?? '',
      statusKeluarga: json['status_keluarga'] ?? '',
      kewarganegaraan: json['kewarganegaraan'] ?? '',
      noPaspor: json['no_paspor'] ?? '',
      noKitap: json['no_kitap'] ?? '',
      namaAyah: json['nama_ayah'] ?? '',
      namaIbu: json['nama_ibu'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
