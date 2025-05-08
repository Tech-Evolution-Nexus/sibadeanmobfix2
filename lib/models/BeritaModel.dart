import 'package:intl/intl.dart';

class Berita {
  final int id;
  final String judul;
  final String keterangan;
  final String konten;
  final String gambar;
  final String createdAt;

  Berita({
    required this.id,
    required this.judul,
    required this.keterangan,
    required this.konten,
    required this.gambar,
    required this.createdAt,
  });

  factory Berita.fromJson(Map<String, dynamic> json) {
    DateTime date = DateTime.parse(json["created_at"]);
    String formatDate = DateFormat('EEEE, d MMMM yyyy', 'id').format(date);
    return Berita(
      id: int.tryParse(json['id'].toString()) ?? 0,
      judul: json['judul'] ?? '',
      keterangan: json['keterangan'] ?? '',
      konten: json['konten'] ?? '',
      gambar: json['gambar'] ?? '',
      createdAt: formatDate,
    );
  }

  @override
  String toString() {
    return 'BeritaModel(judul: $judul, konten: $konten)';
  }
}
