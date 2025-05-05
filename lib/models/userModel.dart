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
    required this.masyarakat,
  });
  

 factory UserModel.fromJson(Map<String, dynamic> json) {
  
  return UserModel(
    
    id: json['user']['id'] ?? 0,
    name: json['user']['name'] ?? '',
    email: json['user']['email'] ?? '',
    token: json['token'] ?? '', // Ambil token langsung
    masyarakat: json['user']['masyarakat'] != null
        ? MasyarakatModel.fromJson(json['user']['masyarakat'])
        : null,
        
  );
}


}

class MasyarakatModel {
  final String nik;
  final String namaLengkap;
  final String jenisKelamin;
  final String tempatLahir;
  final String tanggalLahir;
  final String agama;
  final String pekerjaan;
  final String alamat;
  final String phone;
  final String statusAkun;
  final KartuKeluargaModel? kartuKeluarga;

  MasyarakatModel({
    required this.nik,
    required this.namaLengkap,
    required this.jenisKelamin,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.agama,
    required this.pekerjaan,
    required this.alamat,
    required this.phone,
    required this.statusAkun,
    required this.kartuKeluarga,
  });

  factory MasyarakatModel.fromJson(Map<String, dynamic> json) {
    return MasyarakatModel(
      nik: json['nik'] ?? '',
      namaLengkap: json['nama_lengkap'] ?? '',
      jenisKelamin: json['jenis_kelamin'] ?? '',
      tempatLahir: json['tempat_lahir'] ?? '',
      tanggalLahir: json['tanggal_lahir'] ?? '',
      agama: json['agama'] ?? '',
      pekerjaan: json['pekerjaan'] ?? '',
      alamat: json['alamat'] ?? '',
      phone: json['phone'] ?? '',
      statusAkun: json['status_akun'] ?? '',
      kartuKeluarga: json['kartu_keluarga'] != null
          ? KartuKeluargaModel.fromJson(json['kartu_keluarga'])
          : null,
    );
  }
}

class KartuKeluargaModel {
  final String noKk;
  final String alamat;
  final int rt;
  final int rw;

  KartuKeluargaModel({
    required this.noKk,
    required this.alamat,
    required this.rt,
    required this.rw,
  });

  factory KartuKeluargaModel.fromJson(Map<String, dynamic> json) {
    return KartuKeluargaModel(
      noKk: json['no_kk'] ?? '',
      alamat: json['alamat'] ?? '',
      rt: json['rt'] ?? 0,
      rw: json['rw'] ?? 0,
    );
  }
}
