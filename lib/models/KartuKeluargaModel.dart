class KartuKeluargaModel {
  final String noKk;
  final String alamat;
  final int rt;
  final int rw;
  final String kkgambar;

  KartuKeluargaModel({
    required this.noKk,
    required this.alamat,
    required this.rt,
    required this.rw,
    this.kkgambar = "",
  });

  factory KartuKeluargaModel.fromJson(Map<String, dynamic> json) {
    return KartuKeluargaModel(
      noKk: json['no_kk']??'',
      alamat: json['alamat']??'',
      rt: json['rt']??'',
      rw: json['rw']??'',
      kkgambar: json['kk_gambar']??'',
    );
  }

  @override
  String toString() {
    return 'KartuKeluargaModel(noKk: $noKk, alamat: $alamat, rt: $rt, rw: $rw, kkgambar: $kkgambar)';
  }
}
