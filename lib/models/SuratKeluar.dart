  class SuratKeluar {
    final int id;
    final String title;
    final String namaFile;
    final String expDate;

    SuratKeluar({
      required this.id,
      required this.title,
      required this.namaFile,
      required this.expDate,
    });

    factory SuratKeluar.fromJson(Map<String, dynamic> json) {
      return SuratKeluar(
        id: json['id'],
        title: json['title'],
        namaFile: json['nama_file'],
        expDate: json['exp_date'],
      );
    }
  }
