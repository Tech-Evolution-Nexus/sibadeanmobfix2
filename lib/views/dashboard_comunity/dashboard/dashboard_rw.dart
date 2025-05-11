import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sibadeanmob_v2_fix/methods/api.dart';
import 'package:sibadeanmob_v2_fix/methods/auth.dart';
import 'package:sibadeanmob_v2_fix/models/BeritaSuratModel.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/berita/detail_berita.dart';
import '../../../theme/theme.dart';
import '../profiles/profile.dart';
import '../riwayatsurat/riwayat_surat_rw.dart'; // pastikan ini tersedia

class DashboardRW extends StatefulWidget {
  
  @override
  _DashboardRWState createState() => _DashboardRWState();
}

class _DashboardRWState extends State<DashboardRW> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    HomeRW(),
    RiwayatSuratRW(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: lightColorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.history_rounded), label: "Riwayat"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded), label: "Profil"),
        ],
      ),
    );
  }
}

class HomeRW extends StatefulWidget {
  @override
  _HomeRWState createState() => _HomeRWState();
}

class _HomeRWState extends State<HomeRW> {
  String nama = "User";
  String nik = "";
  String foto = "";
  bool isLoading = true;
  BeritaSuratModel? dataModel;

  @override
  void initState() {
    super.initState();
    getUserData();
    fetchBerita();
  }

  Future<void> getUserData() async {
    final user = await Auth.user();
    setState(() {
      nama = user['nama'] ?? "User";
      nik = user['nik'] ?? "NIK tidak ditemukan";
      foto = user['foto'] ?? "";
    });
  }

  Future<void> fetchBerita() async {
    try {
      var response = await API().getdatadashboard();
      if (response.statusCode == 200) {
        setState(() {
          dataModel = BeritaSuratModel.fromJson(response.data['data']);
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;
    final isSmall = width < 360;

    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        Stack(
          children: [
            buildBackground(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Gap(16),
                  buildHeader(),
                  const Gap(16),
                  cardHero(),
                  const Gap(16),
                ],
              ),
            ),
          ],
        ),
        const Gap(16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: berita(),
        ),
        const Gap(16),
      ],
    );
  }

  Widget buildBackground() {
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: width * 0.5,
      decoration: BoxDecoration(
        color: lightColorScheme.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
    );
  }

  Widget buildHeader() {
    final width = MediaQuery.of(context).size.width;
    final isSmall = width < 360;

    return Row(
      children: [
        CircleAvatar(
          radius: width * 0.07,
          backgroundImage: foto.isNotEmpty
              ? NetworkImage(foto)
              : const AssetImage('assets/images/6.jpg') as ImageProvider,
        ),
        SizedBox(width: width * 0.03),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(nama,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: isSmall ? 14 : 16,
                    fontWeight: FontWeight.bold)),
            Text(nik,
                style: TextStyle(
                    color: Colors.white70, fontSize: isSmall ? 11 : 12)),
          ],
        ),
        const Spacer(),
        const Icon(Icons.notifications, color: Colors.white),
      ],
    );
  }

  Widget cardHero() {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final isSmall = width < 360;

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.04, vertical: height * 0.01),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Pengajuan Surat",
              style: TextStyle(
                  fontSize: isSmall ? 14 : 16, fontWeight: FontWeight.bold)),
          SizedBox(height: height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                  child: _statusItem('Menunggu persetujuan', '17', isSmall)),
              Container(
                  width: 1, height: height * 0.04, color: Colors.grey[300]),
              Expanded(child: _statusItem('Selesai', '20', isSmall)),
            ],
          ),
        ],
      ),
    );
  }

  Widget berita() {
    final width = MediaQuery.of(context).size.width;
    final isSmall = width < 360;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(width * 0.04),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Berita & Peristiwa Badean",
                  style: TextStyle(
                      fontSize: isSmall ? 14 : 16,
                      fontWeight: FontWeight.bold)),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, size: 14),
            ],
          ),
          isLoading || dataModel == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: dataModel!.berita.map((item) {
                    return Column(
                      children: [
                        ListTile(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DetailBerita(id: item.id.toInt()))),
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 4),
                          leading: Image.asset('assets/images/coba.png',
                              width: 40, height: 40, fit: BoxFit.cover),
                          title: Text(item.judul,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: isSmall ? 12 : 14)),
                          subtitle: const Text('18 April 2025'),
                        ),
                        const Divider(height: 1),
                      ],
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2))
      ],
    );
  }

  Widget _statusItem(String title, String count, bool isSmall) {
    return Column(
      children: [
        Text(count,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isSmall ? 16 : 18,
                color: lightColorScheme.primary)),
        const SizedBox(height: 4),
        Text(title,
            style:
                TextStyle(color: Colors.black54, fontSize: isSmall ? 11 : 12),
            textAlign: TextAlign.center),
      ],
    );
  }
}
