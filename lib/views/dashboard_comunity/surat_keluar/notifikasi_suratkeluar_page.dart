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
  List<String> dibacaIds = [];
  bool isDibacaIdsLoaded = false;

  final String baseViewUrl =
      'https://sibadean.kholzt.com/view-pdf?path=surat-keluar';

  @override
  void initState() {
    super.initState();
    loadDibacaIds();
    futureSuratKeluar = API().getSuratKeluar();
  }

  Future<void> loadDibacaIds() async {
    final prefs = await SharedPreferences.getInstance();
    dibacaIds = prefs.getStringList('dibaca_surat') ?? [];
    setState(() {
      isDibacaIdsLoaded = true;
    });
  }

  Future<void> tandaiSuratDibaca(int id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedIds = prefs.getStringList('dibaca_surat') ?? [];

    if (!savedIds.contains(id.toString())) {
      savedIds.add(id.toString());
      await prefs.setStringList('dibaca_surat', savedIds);
      widget.onSuratDibaca();
      loadDibacaIds(); // refresh status baca
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isDibacaIdsLoaded) {
      return Scaffold(
        appBar: AppBar(title: Text('Notifikasi Surat Keluar')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

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

          // Sortir surat berdasarkan expDate terbaru ke terlama
          suratKeluarList.sort((a, b) {
            DateTime dateA = DateTime.tryParse(a.expDate) ?? DateTime(1970);
            DateTime dateB = DateTime.tryParse(b.expDate) ?? DateTime(1970);
            return dateB.compareTo(dateA);
          });

          return ListView.builder(
            itemCount: suratKeluarList.length,
            itemBuilder: (context, index) {
              final surat = suratKeluarList[index];
              final fileUrl = surat.namaFile.startsWith('http')
                  ? surat.namaFile
                  : '$baseViewUrl/${surat.namaFile}';

              final isDibaca = dibacaIds.contains(surat.id.toString());

              return Container(
                color: isDibaca ? Colors.grey[200] : Colors.white,
                child: ListTile(
                  leading: Icon(
                    isDibaca ? Icons.mark_email_read : Icons.markunread,
                    color: isDibaca ? Colors.green : Colors.redAccent,
                  ),
                  title: Text(
                    surat.title,
                    style: TextStyle(
                      fontWeight:
                          isDibaca ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Expired: ${surat.expDate}'),
                      Text(
                        isDibaca ? 'Sudah dibaca' : 'Belum dibaca',
                        style: TextStyle(
                          color: isDibaca ? Colors.green : Colors.redAccent,
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isDibaca
                            ? Icons.check_circle
                            : Icons.notifications_active,
                        color: isDibaca ? Colors.green : Colors.orange,
                      ),
                      IconButton(
                        icon: Icon(Icons.download),
                        onPressed: () {
                          downloadAndOpenFile(
                              context, fileUrl, 'surat_${surat.id}.pdf');
                        },
                      ),
                    ],
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
