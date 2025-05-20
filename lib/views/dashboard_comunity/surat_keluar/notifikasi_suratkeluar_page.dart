import 'package:flutter/material.dart';
import 'package:sibadeanmob_v2_fix/methods/api.dart';
import 'package:sibadeanmob_v2_fix/models/SuratKeluar.dart';

import 'pdf_viewer_page.dart';

class NotifikasiSuratKeluarPage extends StatefulWidget {
  final VoidCallback onSuratDibaca;

  const NotifikasiSuratKeluarPage({Key? key, required this.onSuratDibaca})
      : super(key: key);

  @override
  _NotifikasiSuratKeluarPageState createState() =>
      _NotifikasiSuratKeluarPageState();
}

class _NotifikasiSuratKeluarPageState extends State<NotifikasiSuratKeluarPage> {
  late Future<List<SuratKeluar>> futureSuratKeluar;
  final String baseViewUrl =
      'https://sibadean.kholzt.com/view-pdf?path=surat-keluar';

  @override
  void initState() {
    super.initState();
    futureSuratKeluar = API().getSuratKeluar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifikasi Surat Keluar')),
      body: FutureBuilder<List<SuratKeluar>>(
        future: futureSuratKeluar,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada surat keluar'));
          }

          final suratKeluarList = snapshot.data!;

          return ListView.builder(
            itemCount: suratKeluarList.length,
            itemBuilder: (context, index) {
              final surat = suratKeluarList[index];

              final fileUrl = surat.namaFile.startsWith('http')
                  ? surat.namaFile
                  : '$baseViewUrl/${surat.namaFile}';

              return ListTile(
                  leading: Icon(Icons.mail_outline),
                  title: Text(surat.title),
                  subtitle: Text('Expired: ${surat.expDate}'),
                  onTap: () {
                    widget
                        .onSuratDibaca(); // panggil callback untuk kurangi badge

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            PDFViewerPage(url: fileUrl, title: surat.title),
                      ),
                    );
                  });
            },
          );
        },
      ),
    );
  }
}
