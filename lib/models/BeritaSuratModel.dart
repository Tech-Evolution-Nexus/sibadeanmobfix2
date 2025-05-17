import 'package:sibadeanmob_v2_fix/models/DashModel.dart';

import 'BeritaModel.dart';
import 'SuratModel.dart';

class BeritaSuratModel {
  final DashModel dash;
  List<Berita> berita = [];
  List<Surat> surat = [];

  BeritaSuratModel({
    required this.berita,
    required this.surat,
    required this.dash,
  });

  factory BeritaSuratModel.fromJson(Map<String, dynamic> json) {
    return BeritaSuratModel(
      dash: DashModel.fromJson(json['dash'] ?? {}),
      berita: (json['berita'] as List<dynamic>)
          .map((item) => Berita.fromJson(item))
          .toList(),
      surat: (json['surat'] as List<dynamic>)
          .map((item) => Surat.fromJson(item))
          .toList(),
    );
  }
}
