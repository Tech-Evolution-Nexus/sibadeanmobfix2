import 'package:sibadeanmob_v2_fix/models/FieldsModel.dart';
import 'package:sibadeanmob_v2_fix/models/LampiranSuratModel.dart';

class SuratLampiranModel {
  final int id;
  final String namaSurat;
  final String gambar;
  final List<Lampiransuratmodel> lampiransurat;
  final List<FieldsModel> fields;

  SuratLampiranModel({
    required this.id,
    required this.namaSurat,
    required this.gambar,
    required this.lampiransurat,
    required this.fields,
  });

  factory SuratLampiranModel.fromJson(Map<String, dynamic> json) {
    return SuratLampiranModel(
      id: json['id'],
      namaSurat: json['nama_surat'],
      gambar: json['gambar'],
      lampiransurat: (json['lampiransurat'] as List)
          .map((item) => Lampiransuratmodel.fromJson(item))
          .toList(),
      fields: (json['fields'] as List)
          .map((item) => FieldsModel.fromJson(item))
          .toList(),
    );
  }
}
