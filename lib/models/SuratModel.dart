class Surat {
  final int id;
  final String nama_surat;
  final String gambar;

  Surat({
    required this.id,
    required this.nama_surat,
    required this.gambar,
  });

  factory Surat.fromJson(Map<String, dynamic> json) {
    return Surat(
      id: json['id'] ?? '',
      nama_surat: json['nama_surat'] ?? '',
      gambar: json['gambar'] ?? '',
    );
  }
  @override
  String toString() {
    return 'BeritaModel(nama_surat: $nama_surat, gambar: $gambar)';
  }
}
