import 'package:flutter/material.dart';
import 'package:sibadeanmob_v2_fix/methods/api.dart';
import 'package:sibadeanmob_v2_fix/models/SuratKeluar.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/surat_keluar/pdf_viewer_page.dart';

class NotifikasiSuratKeluarPage extends StatefulWidget {
  @override
  _NotifikasiSuratKeluarPageState createState() =>
      _NotifikasiSuratKeluarPageState();
}

class _NotifikasiSuratKeluarPageState extends State<NotifikasiSuratKeluarPage> {
  late Future<List<SuratKeluar>> futureSuratKeluar;

  @override
  void initState() {
    super.initState();
    futureSuratKeluar = API().getSuratKeluar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifikasi Surat Keluar'),
      ),
      body: FutureBuilder<List<SuratKeluar>>(
        future: futureSuratKeluar,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada surat keluar'));
          }

          final suratKeluarList = snapshot.data!;
          return ListView.builder(
            itemCount: suratKeluarList.length,
            itemBuilder: (context, index) {
              final surat = suratKeluarList[index];
              return ListTile(
                leading: Icon(Icons.mail_outline),
                title: Text(surat.title),
                subtitle: Text('Expired: ${surat.expDate}'),
                onTap: () {
                  final baseUrl =
                      'https://sibadean.kholzt.com'; // Ganti dengan domain/server kamu
                  final fileUrl =
                      '$baseUrl/storage/surat-keluar/${surat.namaFile}';

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PDFViewerPage(
// <<<<<<< HEAD
                        url: fileUrl,
                        title: surat.title,
                      ),
// =======
//                           url: surat.namaFile, title: surat.title),
// >>>>>>> 0b74f1409a07a8d8010488538936cc970003c713
                     ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
