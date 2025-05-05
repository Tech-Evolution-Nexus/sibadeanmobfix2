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
      'status': 'Menunggu Rw',
    },
    {
      'namaPengguna': 'Siti Aminah',
      'namaSurat': 'Surat Domisili',
      'tanggal': '2 Mei 2025',
      'status': 'Diterima Rw',
    },
    {
      'namaPengguna': 'Budi Hartono',
      'namaSurat': 'Surat Izin Penelitian',
      'tanggal': '1 Mei 2025',
      'status': 'Ditolak',
    },
  ];
  List<PengajuanSurat>? pengajuanModel;

  @override
  void initState() {
    super.initState();
    fetchData();
    _tabController = TabController(length: 4, vsync: this);
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
      case 'diterima':
        color = Colors.green;
        break;
      case 'ditolak':
        color = Colors.red;
        break;
      case 'diproses':
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
      case 'Diterima':
        return Colors.green;
      case 'Ditolak':
        return Colors.red;
      case 'Diproses':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Widget statusSurat(String tabTitle) {
    // print(pengajuanModel);
    return ListView.builder(
      itemCount: daftarSurat.length,
      itemBuilder: (context, index) {
        final surat = daftarSurat[index];
        Color headerColor = getHeaderColor(surat['status'] ?? "");

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          // elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            onTap: () {
              // Aksi saat card ditekan (misalnya, menampilkan detail)
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Surat ${surat['namaSurat']} ditekan')),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header dengan status dan ikon
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: headerColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline, // Ikon default
                          color: Colors.white,
                        ),
                        SizedBox(width: 8),
                        Text(
                          '${surat['status']}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Body card dengan data surat
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${surat['namaSurat']}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Nama Pengguna: ${surat['namaPengguna']}',
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tanggal Pengajuan: ${surat['tanggal']}',
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[500]),
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
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
            Tab(text: "Diterima"),
            Tab(text: "Download"),
            Tab(text: "Dibatalkan"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          statusSurat("Menunggu"),
          statusSurat("Diterima"),
          statusSurat("Download"),
          statusSurat("Dibatalkan"),
        ],
      ),
    );
  }
}
