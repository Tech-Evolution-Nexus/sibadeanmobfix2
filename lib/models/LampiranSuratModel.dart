import 'package:sibadeanmob_v2_fix/models/LampiranModel.dart';

class Lampiransuratmodel {
  final int id;
  final int idSurat;
  final int idLampiran;
  final LampiranModel lampiran;

  Lampiransuratmodel({
    required this.id,
    required this.idSurat,
    required this.idLampiran,

    required this.lampiran,
  });

  factory Lampiransuratmodel.fromJson(Map<String, dynamic> json) {
    return Lampiransuratmodel(
      id: json['id'],
      idSurat: json['id_surat'],
      idLampiran: json['id_lampiran'],
      lampiran: LampiranModel.fromJson(json['lampiran']),
    );
  }
}