class UserModel {
  final int id;
  final String name;
  final String email;
  final String token;
  final MasyarakatModel? masyarakat;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
    this.masyarakat,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['user']['id'] ?? 0,
      name: json['user']['name'] ?? '',
      email: json['user']['email'] ?? '',
      token: json['token'] ?? '',
      masyarakat: json['user']['masyarakat'] != null
          ? MasyarakatModel.fromJson(json['user']['masyarakat'])
          : null,
    );
  }
}

class MasyarakatModel {
  final String nik;
  final String? namaLengkap;
  final String? jenisKelamin;
  final String? tempatLahir;
  final String? tanggalLahir;
  final String? agama;
  final String? pendidikan;
  final String? pekerjaan;
  final String? golonganDarah;
  final String? statusPerkawinan;
  final String? tanggalPerkawinan;
  final String? statusKeluarga;
  final String? kewarganegaraan;
  final String? noPaspor;
  final String? noKitap;
  final String? namaAyah;
  final String? namaIbu;
  final String? alamat;
  final String? phone;
  final String? statusAkun;
  final KartuKeluargaModel? kartuKeluarga;

  MasyarakatModel({
    required this.nik,
    this.namaLengkap,
    this.jenisKelamin,
    this.tempatLahir,
    this.tanggalLahir,
    this.agama,
    this.pendidikan,
    this.pekerjaan,
    this.golonganDarah,
    this.statusPerkawinan,
    this.tanggalPerkawinan,
    this.statusKeluarga,
    this.kewarganegaraan,
    this.noPaspor,
    this.noKitap,
    this.namaAyah,
    this.namaIbu,
    this.alamat,
    this.phone,
    this.statusAkun,
    this.kartuKeluarga,
  });

  factory MasyarakatModel.fromJson(Map<String, dynamic> json) {
    return MasyarakatModel(
      nik: json['nik'] ?? '',
      namaLengkap: json['nama_lengkap'],
      jenisKelamin: json['jenis_kelamin'],
      tempatLahir: json['tempat_lahir'],
      tanggalLahir: json['tanggal_lahir'],
      agama: json['agama'],
      pendidikan: json['pendidikan'],
      pekerjaan: json['pekerjaan'],
      golonganDarah: json['golongan_darah'],
      statusPerkawinan: json['status_perkawinan'],
      tanggalPerkawinan: json['tanggal_perkawinan'],
      statusKeluarga: json['status_keluarga'],
      kewarganegaraan: json['kewarganegaraan'],
      noPaspor: json['no_paspor'],
      noKitap: json['no_kitap'],
      namaAyah: json['nama_ayah'],
      namaIbu: json['nama_ibu'],
      alamat: json['kartu_keluarga']?['alamat'],
      phone: json['phone'],
      statusAkun: json['status_akun'],
      kartuKeluarga: json['kartu_keluarga'] != null
          ? KartuKeluargaModel.fromJson(json['kartu_keluarga'])
          : null,
    );
  }
}

class KartuKeluargaModel {
  final String? noKk;
  final String? alamat;
  final int? rt;
  final int? rw;

  KartuKeluargaModel({
    this.noKk,
    this.alamat,
    this.rt,
    this.rw,
  });

  factory KartuKeluargaModel.fromJson(Map<String, dynamic> json) {
    return KartuKeluargaModel(
      noKk: json['no_kk'],
      alamat: json['alamat'],
      rt: json['rt'],
      rw: json['rw'],
    );
  }
}
