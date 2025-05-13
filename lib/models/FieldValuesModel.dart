class FieldValuesModel {
  final String namaField;
  final String value;

  FieldValuesModel({
    required this.namaField,
    required this.value,
  });

  factory FieldValuesModel.fromJson(Map<String, dynamic> json) {
    return FieldValuesModel(
      namaField: json['nama_field'],
      value: json['value'],
    );
  }
}
