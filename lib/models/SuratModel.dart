class Surat {
  final int id;
  final String nama_surat;
  final String singkatanNamaSurat;
  final String gambar;

  Surat({
    required this.id,
    required this.nama_surat,
    required this.singkatanNamaSurat,
    required this.gambar,
  });

  factory Surat.fromJson(Map<String, dynamic> json) {
    return Surat(
      id: json['id'] ?? '',
      nama_surat: json['nama_surat'] ?? '',
      gambar: json['gambar'] ?? '',
      singkatanNamaSurat: json['singkatan_nama_surat'] ?? '',
    );
  }
  @override
  String toString() {
    return 'BeritaModel(nama_surat: $nama_surat, gambar: $gambar)';
  }
}
