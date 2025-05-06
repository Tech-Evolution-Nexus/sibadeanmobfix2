import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sibadeanmob_v2_fix/methods/auth.dart';
import 'package:sibadeanmob_v2_fix/models/PengajuanModel.dart';
import '../../../theme/theme.dart';
import '/methods/api.dart';

class PengajuanPage extends StatefulWidget {
  @override
  _PengajuanPageState createState() => _PengajuanPageState();
}

class _PengajuanPageState extends State<PengajuanPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> daftarSurat = [
    {
      'namaPengguna': 'Ahmad Fauzi',
      'namaSurat': 'Surat Keterangan Aktif',
      'tanggal': '5 Mei 2025',
      'status': 'di_terima_rw',
    },
    {
      'namaPengguna': 'Siti Aminah',
      'namaSurat': 'Surat Domisili',
      'tanggal': '2 Mei 2025',
      'status': 'di_terima_rw',
    },
    {
      'namaPengguna': 'Budi Hartono',
      'namaSurat': 'Surat Izin Penelitian',
      'tanggal': '1 Mei 2025',
      'status': 'di_terima_rw',
    },
    {
      'namaPengguna': 'Budi Hartono',
      'namaSurat': 'Surat Izin Penelitian',
      'tanggal': '1 Mei 2025',
      'status': 'di_terima_rw',
    },
  ];
  List<PengajuanSurat>? pengajuanModel;

  @override
  void initState() {
    super.initState();
    fetchData();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    try {
      // print("test");
      final user = await Auth.user();

      var response = await API().getRiwayatPengajuan(nik: user["nik"]);

      if (response.statusCode == 200) {
        print(response.data["data"]);
        setState(() {
          pengajuanModel = (response.data["data"] as List)
              .map((item) => PengajuanSurat.fromJson(item))
              .toList();
          // isLoading = false;
        });
      }
    } catch (e) {
      // print("Error: $e");
      // setState(() => isLoading = false);
    }
  }

  Widget buildStatusText(String? status) {
    Color color;
    switch (status?.toLowerCase()) {
      case 'selesai':
        color = Colors.green;
        break;
      case 'ditolak':
        color = Colors.red;
        break;
      case 'pending':
        color = Colors.grey;
        break;
      case 'di_terima_rw':
      case 'di_terima_rt':
        color = Colors.orange;
        break;
      default:
        color = Colors.grey;
    }

    return Text(
      status ?? 'Tidak Diketahui',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
    );
  }

  Color getHeaderColor(String status) {
    switch (status) {
      case 'selesai':
        return Colors.green;
      case 'ditolak':
        return Colors.red;
      case 'pending':
        return Colors.grey;
      case 'di_terima_rw':
      case 'di_terima_rt':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String formatStatus(String status) {
    switch (status) {
      case 'selesai':
        return "Selesai";
      case 'ditolak':
        return "Ditolak";
      case 'pending':
        return "Menunggu";
      case 'di_terima_rw':
      case 'di_terima_rt':
        return "Diterima Rw";
      default:
        return "Menunggu";
    }
  }

  Widget statusSurat(String tabTitle) {
    return ListView.builder(
      itemCount: daftarSurat.length,
      itemBuilder: (context, index) {
        final surat = daftarSurat[index];
        Color headerColor = getHeaderColor(surat['status'] ?? "");

        return Card(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Surat ${surat['namaSurat']} ditekan')),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    color: headerColor,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.mail_outline,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '${formatStatus(surat['status'] ?? "")}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Spacer(),
                      Text(
                        'Pengajuan: ${surat['tanggal']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.9),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),

                // Body
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${surat['namaSurat']}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.person, size: 16, color: Colors.grey[600]),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Pengguna: ${surat['namaPengguna']}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightColorScheme.primary,
        title: Text("Pengajuan Surat", style: TextStyle(color: Colors.white)),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: "Menunggu"),
            Tab(text: "Diproses"),
            Tab(text: "Download"),
            Tab(text: "Ditolak"),
            Tab(text: "Dibatalkan"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          statusSurat("Menunggu"),
          statusSurat("Diproses"),
          statusSurat("Download"),
          statusSurat("Ditolak"),
          statusSurat("Dibatalkan"),
        ],
      ),
    );
  }
}
