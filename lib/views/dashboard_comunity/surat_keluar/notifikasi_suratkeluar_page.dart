import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sibadeanmob_v2_fix/methods/api.dart';
import 'package:sibadeanmob_v2_fix/models/SuratKeluar.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/surat_keluar/file_utils.dart';

import 'pdf_viewer_page.dart';

class NotifikasiSuratKeluarPage extends StatefulWidget {
  final VoidCallback onSuratDibaca;

  NotifikasiSuratKeluarPage({required this.onSuratDibaca});

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

  Future<void> tandaiSuratDibaca(int id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> dibacaIds = prefs.getStringList('dibaca_surat') ?? [];

    if (!dibacaIds.contains(id.toString())) {
      dibacaIds.add(id.toString());
      await prefs.setStringList('dibaca_surat', dibacaIds);
      widget.onSuratDibaca(); // refresh dashboard badge
    }
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
                trailing: IconButton(
                  icon: Icon(Icons.download),
                  onPressed: () {
                    downloadAndOpenFile(
                        context, fileUrl, 'surat_${surat.id}.pdf');
                  },
                ),
                onTap: () async {
                  await tandaiSuratDibaca(surat.id);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          PDFViewerPage(url: fileUrl, title: surat.title),
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
