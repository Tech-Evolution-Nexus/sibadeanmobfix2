import 'package:flutter/material.dart';
import 'pengajuan_surat.dart';
import '../../../theme/theme.dart';

class ListSurat extends StatelessWidget {
  final List<String> daftarSurat = [
    "Surat Keterangan Domisili",
    "Surat Keterangan Tidak Mampu",
    "Surat Keterangan Usaha",
    "Surat Keterangan Kelahiran",
    "Surat Keterangan Kematian",
    "Surat Izin Keramaian",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Semua Surat",style: TextStyle(color: Colors.white,fontSize: 15),),
        backgroundColor: lightColorScheme.primary,
         iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: daftarSurat.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: Icon(Icons.article_rounded, color: lightColorScheme.primary,),
              title: Text(daftarSurat[index],
                  style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PengajuanSuratPage(
                     
                      namaSurat: daftarSurat[index],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
