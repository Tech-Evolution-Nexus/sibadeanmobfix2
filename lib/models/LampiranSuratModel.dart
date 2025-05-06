import 'package:sibadeanmob_v2_fix/models/LampiranModel.dart';

class LampiranSuratModel {
  final int idLampiran;
  final LampiranModel lampiran;

  LampiranSuratModel({required this.idLampiran, required this.lampiran});

  factory LampiranSuratModel.fromJson(Map<String, dynamic> json) {
    return LampiranSuratModel(
      idLampiran: json['id_lampiran'],
      lampiran: LampiranModel.fromJson(json['lampiran']),
    );
  }
}
