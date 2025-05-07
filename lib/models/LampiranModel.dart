class LampiranModel {
  final int id;
  final String namaLampiran;

  LampiranModel({
    required this.id,
    required this.namaLampiran,
  });

  factory LampiranModel.fromJson(Map<String, dynamic> json) {
    return LampiranModel(
      id: json['id'],
      namaLampiran: json['nama_lampiran'],
    );
  }
}
