class Berita {
  final int id;
  final String judul;
  final String keterangan;
  final String konten;
  final String gambar;

  Berita({
    required this.id,
    required this.judul,
    required this.keterangan,
    required this.konten,
    required this.gambar,
  });

  factory Berita.fromJson(Map<String, dynamic> json) {
    return Berita(
        id: int.tryParse(json['id'].toString()) ?? 0,
      judul: json['judul'] ?? '',
      keterangan: json['keterangan'] ?? '',
      konten: json['konten'] ?? '',
      gambar: json['gambar'] ?? '',
    );
  }
  @override
  String toString() {
    return 'BeritaModel(judul: $judul, konten: $konten)';
  }
}
