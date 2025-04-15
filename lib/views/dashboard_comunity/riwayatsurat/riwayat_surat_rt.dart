import 'package:flutter/material.dart';

class RiwayatSuratRT extends StatefulWidget {
  @override
  _RiwayatSuratRTState createState() => _RiwayatSuratRTState();
}

class _RiwayatSuratRTState extends State<RiwayatSuratRT> {
  List<String> suratMasuk = [
    "Pengajuan Surat Keterangan Domisili",
    "Pengajuan Surat Keterangan Usaha",
    "Pengajuan Surat Keterangan Tidak Mampu"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Riwayat Surat Masuk")),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: suratMasuk.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 5),
            child: ListTile(
              title: Text(suratMasuk[index]),
              subtitle: Text("Menunggu persetujuan RT"),
              trailing: ElevatedButton(
                onPressed: () {
                  // Aksi untuk ACC surat
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
