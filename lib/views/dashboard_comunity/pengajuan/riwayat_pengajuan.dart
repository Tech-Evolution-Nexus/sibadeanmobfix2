import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sibadeanmob_v2_fix/methods/auth.dart';
import 'package:sibadeanmob_v2_fix/models/PengajuanModel.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/pengajuan/detail_riwayat.dart';

import '/methods/api.dart';
import '../../../theme/theme.dart';

class PengajuanPage extends StatefulWidget {
  const PengajuanPage({super.key});

  @override
  _PengajuanPageState createState() => _PengajuanPageState();
}

class _PengajuanPageState extends State<PengajuanPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<PengajuanSurat> pengajuanMenunggu = [];
  List<PengajuanSurat> pengajuanProses = [];
  List<PengajuanSurat> pengajuanSelesai = [];
  List<PengajuanSurat> pengajuanTolak = [];
  List<PengajuanSurat> pengajuanBatal = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: lightColorScheme.primary,
        backgroundColor: lightColorScheme.primary,
        title: Text("Pengajuan Surat",
            style: TextStyle(color: Colors.white, fontSize: 20)),
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
      body: RefreshIndicator(
        onRefresh: fetchData, // This is where data will be refreshed
        child: TabBarView(
          controller: _tabController,
          children: [
            statusSurat("Menunggu", pengajuanMenunggu),
            statusSurat("Diproses", pengajuanProses),
            statusSurat("Download", pengajuanSelesai),
            statusSurat("Ditolak", pengajuanTolak),
            statusSurat("Dibatalkan", pengajuanBatal),
          ],
        ),
      ),
    );
  }

  Widget statusSurat(String tabTitle, List<PengajuanSurat> pengajuan) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;
    return ListView.builder(
      itemCount: pengajuan.length ?? 0,
      itemBuilder: (context, index) {
        final surat = pengajuan[index];
        Color headerColor = getHeaderColor(surat?.status ?? "");

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Colors.black26,
              width: .2,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailRiwayat(
                          idPengajuan: surat?.id ?? 0,
                        )),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: width * 0.05,
                        backgroundColor: headerColor,
                        child:
                            const Icon(Icons.mail_rounded, color: Colors.white),
                      ),
                      Gap(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    surat?.surat.nama_surat ?? "",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  formatStatus(surat?.status ?? ""),
                                  style: TextStyle(
                                      color: headerColor, fontSize: 14),
                                ),
                              ],
                            ),
                            Gap(6),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    surat?.masyarakat.namaLengkap ?? "",
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 12),
                                  ),
                                ),
                                Text(
                                  surat?.createdAt ?? "",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
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

  Future<void> fetchData() async {
    try {
      // print("test");
      final user = await Auth.user();

      var response = await API().getRiwayatPengajuan(nik: user["nik"]);

      if (response.statusCode == 200) {
        setState(() {
          pengajuanMenunggu =
              (response.data["data"]["pengajuanMenunggu"] as List)
                  .map((item) => PengajuanSurat.fromJson(item))
                  .toList();
          pengajuanProses = (response.data["data"]["pengajuanProses"] as List)
              .map((item) => PengajuanSurat.fromJson(item))
              .toList();
          pengajuanSelesai = (response.data["data"]["pengajuanSelesai"] as List)
              .map((item) => PengajuanSurat.fromJson(item))
              .toList();
          pengajuanTolak = (response.data["data"]["pengajuanTolak"] as List)
              .map((item) => PengajuanSurat.fromJson(item))
              .toList();
          pengajuanBatal = (response.data["data"]["pengajuanBatal"] as List)
              .map((item) => PengajuanSurat.fromJson(item))
              .toList();
          // isLoading = false;
        });
      }
    } catch (e) {
      print("Error: $e");
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
      case 'di_tolak_rt':
      case 'di_tolak_rw':
      case 'di_tolak_lurah':
        return Colors.red;
      case 'pending':
        return Colors.grey;
      case 'dibatalkan':
        return Colors.red;
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
      case 'di_tolak_rt':
      case 'di_tolak_rw':
      case 'di_tolak_lurah':
        return "Ditolak";
      case 'pending':
        return "Menunggu";
      case 'dibatalkan':
        return "Dibatalkan";
      case 'di_terima_rw':
      case 'di_terima_rt':
        return "Diterima Rw";
      default:
        return "Menunggu";
    }
  }
}
