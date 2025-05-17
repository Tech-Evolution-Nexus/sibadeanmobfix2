class DashModel {
  final int totalMenungguPersetujuan;
  final int totalPersetujuanSelesai;

  DashModel({
    required this.totalMenungguPersetujuan,
    required this.totalPersetujuanSelesai,
  });

  factory DashModel.fromJson(Map<String, dynamic> json) {
    return DashModel(
      totalMenungguPersetujuan: json['total_menunggu_persetujuan'] ?? 0,
      totalPersetujuanSelesai: json['total_persetujuan_selesai'] ?? 0,
    );
  }
}
