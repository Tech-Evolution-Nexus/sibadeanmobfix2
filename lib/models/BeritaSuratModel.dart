import 'BeritaModel.dart';
import 'SuratModel.dart';

class BeritaSuratModel {
  final List<Berita> berita;
  final List<Surat> surat;

  BeritaSuratModel({
    required this.berita,
    required this.surat,
  });

  factory BeritaSuratModel.fromJson(Map<String, dynamic> json) {
    return BeritaSuratModel(
      berita: (json['berita'] as List<dynamic>)
          .map((item) => Berita.fromJson(item))
          .toList(),
      surat: (json['surat'] as List<dynamic>)
          .map((item) => Surat.fromJson(item))
          .toList(),
    );
  }
}
