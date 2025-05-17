import 'package:intl/intl.dart';
import 'package:sibadeanmob_v2_fix/models/KartuKeluargaModel.dart';
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
  final String? tanggalPerkawinan;
  final String statusKeluarga;
  final String kewarganegaraan;
  final String? noPaspor;
  final String? noKitap;
  final String namaAyah;
  final String namaIbu;
  final String createdAt;
  final String? ktpgambar;
  final KartuKeluargaModel? kartuKeluarga;
  final UserModel? user;

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
    this.tanggalPerkawinan,
    required this.statusKeluarga,
    required this.kewarganegaraan,
    this.noPaspor,
    this.noKitap,
    required this.namaAyah,
    required this.namaIbu,
    required this.createdAt,
    this.ktpgambar,
    required this.kartuKeluarga,
    required this.user,
  });

  factory MasyarakatModel.fromJson(Map<String, dynamic> json) {
    String formattedDate = DateFormat('dd/MM/yyyy').format(
        DateTime.parse(json['created_at'] ?? DateTime.now().toString()));
    String tanggalLahir = json['tanggal_lahir'] != null
        ? DateFormat('d MMMM yyyy', 'id')
            .format(DateTime.parse(json['tanggal_lahir']))
        : "-";
    String tanggalPerkawinan = json['tanggal_perkawinan'] != null
        ? DateFormat('d MMMM yyyy', 'id')
            .format(DateTime.parse(json['tanggal_perkawinan']))
        : "-";

    return MasyarakatModel(
      nik: json['nik'] ?? '',
      idUser: int.tryParse(json['id_user']?.toString() ?? '') ?? 0,
      noKk: json['no_kk'] ?? '',
      namaLengkap: json['nama_lengkap'] ?? '',
      jenisKelamin: json['jenis_kelamin'] ?? '',
      tempatLahir: json['tempat_lahir'] ?? '',
      tanggalLahir: tanggalLahir ?? '',
      agama: json['agama'] ?? '',
      pendidikan: json['pendidikan'] ?? '',
      pekerjaan: json['pekerjaan'] ?? '',
      golonganDarah: json['golongan_darah'] ?? '',
      statusPerkawinan: json['status_perkawinan'] ?? '',
      tanggalPerkawinan: tanggalPerkawinan,
      statusKeluarga: json['status_keluarga'] ?? '',
      kewarganegaraan: json['kewarganegaraan'] ?? '',
      noPaspor: json['no_paspor'] ?? '',
      noKitap: json['no_kitap'] ?? '',
      namaAyah: json['nama_ayah'] ?? '',
      namaIbu: json['nama_ibu'] ?? '',
      createdAt: formattedDate,
      ktpgambar: json['ktp_gambar'] ?? '',
      kartuKeluarga: json['kartu_keluarga'] != null
          ? KartuKeluargaModel.fromJson(json['kartu_keluarga'])
          : null,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  @override
  String toString() {
    return '''
MasyarakatModel(
  nik: $nik,
  idUser: $idUser,
  noKk: $noKk,
  namaLengkap: $namaLengkap,
  jenisKelamin: $jenisKelamin,
  tempatLahir: $tempatLahir,
  tanggalLahir: $tanggalLahir,
  agama: $agama,
  pendidikan: $pendidikan,
  pekerjaan: $pekerjaan,
  golonganDarah: $golonganDarah,
  statusPerkawinan: $statusPerkawinan,
  tanggalPerkawinan: $tanggalPerkawinan,
  statusKeluarga: $statusKeluarga,
  kewarganegaraan: $kewarganegaraan,
  noPaspor: $noPaspor,
  noKitap: $noKitap,
  namaAyah: $namaAyah,
  namaIbu: $namaIbu,
  createdAt: $createdAt,
  ktpgambar: $ktpgambar,
  kartuKeluarga: ${kartuKeluarga?.toString()},
  user: ${user?.toString()}
)
''';
  }
}
