import 'package:flutter/material.dart';

class RiwayatSuratRW extends StatefulWidget {
  @override
  _RiwayatSuratRWState createState() => _RiwayatSuratRWState();
}

class _RiwayatSuratRWState extends State<RiwayatSuratRW> {
  List<String> suratMasuk = [
    "Pengajuan Surat Keterangan Domisili",
    "Pengajuan Surat Keterangan Usaha",
    "Pengajuan Surat Keterangan Tidak Mampu"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Riwayat Surat Masuk RW")),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: suratMasuk.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 5),
            child: ListTile(
              title: Text(suratMasuk[index]),
              subtitle: Text("Menunggu persetujuan RW"),
              trailing: ElevatedButton(
                onPressed: () {
                  // Aksi untuk ACC surat oleh RW
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: Text("ACC"),
              ),
            ),
          );
        },
      ),
    );
  }
}
