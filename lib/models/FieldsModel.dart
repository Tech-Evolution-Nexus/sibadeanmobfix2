class FieldsModel {
  final int id;
  final int idSurat;
  final String namaField;

  FieldsModel({
    required this.id,
    required this.idSurat,
    required this.namaField,
  });

  factory FieldsModel.fromJson(Map<String, dynamic> json) {
    return FieldsModel(
      id: json['id'],
      idSurat: json['id_surat'],
      namaField: json['nama_field'],
    );
  }
}
