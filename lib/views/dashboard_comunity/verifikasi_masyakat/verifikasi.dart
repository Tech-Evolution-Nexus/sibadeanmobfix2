import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sibadeanmob_v2_fix/methods/auth.dart';
import 'package:sibadeanmob_v2_fix/models/MasyarakatModel.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/verifikasi_masyakat/detail.dart';

import '/methods/api.dart';
import '../../../theme/theme.dart';

class Verifikasi extends StatefulWidget {
  const Verifikasi({super.key});

  @override
  _VerifikasiState createState() => _VerifikasiState();
}

class _VerifikasiState extends State<Verifikasi>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<MasyarakatModel> verifikasiMasyarakatMenunggu = [];
  List<MasyarakatModel> verifikasiMasyarakatSelesai = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
    _tabController = TabController(length: 2, vsync: this);
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
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        automaticallyImplyLeading: false,
        // backgroundColor:  Theme.of(context).colorScheme.primary,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text("Verifikasi Masyarakat",
            style: TextStyle(color: Colors.white, fontSize: 20)),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          // tabAlignment: TabAlignment.start,
          tabs: [
            Tab(text: "Menunggu"),
            Tab(text: "Selesai"),
          ],
        ),
      ),
      body: SafeArea(
          child: RefreshIndicator(
        onRefresh: fetchData, // This is where data will be refreshed
        child: TabBarView(
          physics: AlwaysScrollableScrollPhysics(),
          controller: _tabController,
          children: [
            statusSurat("Menunggu", verifikasiMasyarakatMenunggu),
            statusSurat("Selesai", verifikasiMasyarakatSelesai),
          ],
        ),
      )),
    );
  }

  Widget statusSurat(String tabTitle, List<MasyarakatModel> pengajuan) {
    return RefreshIndicator(
      onRefresh: fetchData,
      child: pengajuan.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Center(child: Text("Tidak ada data")),
                ),
              ],
            )
          : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: pengajuan.length,
              itemBuilder: (context, index) {
                final surat = pengajuan[index];
                return Card(
                  margin: EdgeInsets.only(
                    top: index == 0 ? 10 : 4,
                    bottom: 4,
                    left: 16,
                    right: 16,
                  ),
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.black26, width: .2),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailVerifikasi(
                            idUser: surat.idUser,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: MediaQuery.of(context).size.width * 0.05,
                            backgroundColor: surat.user?.status == 0
                                ? Colors.grey
                                : (surat.user?.status == -1
                                    ? Colors.red
                                    : Colors.green),
                            child: const Icon(Icons.person_2_outlined,
                                color: Colors.white),
                          ),
                          const Gap(12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        surat.namaLengkap ?? "",
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 14),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      formatStatus(surat.user?.status ?? 0),
                                      style: TextStyle(
                                        color: surat.user?.status == 0
                                            ? Colors.grey
                                            : (surat.user?.status == -1
                                                ? Colors.red
                                                : Colors.green),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(6),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        surat.nik ?? "",
                                        style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12),
                                      ),
                                    ),
                                    Text(
                                      surat.createdAt ?? "",
                                      style: const TextStyle(
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
                  ),
                );
              },
            ),
    );
  }

  Future<void> fetchData() async {
    try {
      // print("test");
      final user = await Auth.user();

      var response = await API().verifikasiMasyarakat();
      if (response.statusCode == 200) {
        setState(() {
          verifikasiMasyarakatMenunggu =
              (response.data["data"]["verifikasiMenunggu"] as List)
                  .map((item) => MasyarakatModel.fromJson(item))
                  .toList();
          verifikasiMasyarakatSelesai =
              (response.data["data"]["verifikasiSelesai"] as List)
                  .map((item) => MasyarakatModel.fromJson(item))
                  .toList();
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  String formatStatus(int status) {
    print("status $status");
    switch (status) {
      case 1:
        return "Selesai";
      case -1:
        return "Ditolak";
      default:
        return "Menunggu";
    }
  }
}
