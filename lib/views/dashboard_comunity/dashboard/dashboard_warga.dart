import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sibadeanmob_v2_fix/models/BeritaSuratModel.dart';
import 'package:sibadeanmob_v2_fix/models/SuratModel.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/pengajuan/riwayat_pengajuan.dart';
import '../../../theme/theme.dart';
import '../pengajuan/list_surat.dart';
import '../pengajuan/pengajuan_surat.dart';
import '../profiles/profile.dart' show ProfilePage;
import '/methods/api.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0; //navigasi butoon
  final List<Widget> _pages = [
    DashboardContent(),
    PengajuanPage(),
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
        backgroundColor: Colors.white,
        selectedItemColor: lightColorScheme.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: false,
        elevation: 10,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.mail_rounded), label: "Pengajuan"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded), label: "Profil"),
        ],
      ),
    );
  }
}

class DashboardContent extends StatefulWidget {
  @override
  _DashboardContentState createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nama = prefs.getString('nama') ?? "User";
      nik = prefs.getString('nik') ?? "NIK tidak ditemukan";
      foto = prefs.getString('foto') ?? "";
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
                  cardhero(),
                  const Gap(16),
                  pengajuan(),
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
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    return Container(
      height: width * 0.6,
      decoration: BoxDecoration(
        color: lightColorScheme.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
    );
  }

  Widget buildHeader() {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final isSmall = width < 360;
    return Row(
      children: [
        CircleAvatar(
          radius: width * 0.07,
          backgroundImage: foto.isNotEmpty
              ? NetworkImage(foto)
              : const AssetImage('assets/images/oled.jpg') as ImageProvider,
        ),
        SizedBox(width: width * 0.03),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nama,
              style: TextStyle(
                color: Colors.white,
                fontSize: isSmall ? 14 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              nik,
              style: TextStyle(
                color: Colors.white70,
                fontSize: isSmall ? 11 : 12,
              ),
            ),
          ],
        ),
        const Spacer(),
        const Icon(Icons.notifications, color: Colors.white),
      ],
    );
  }

  Widget cardhero() {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;
    final isSmall = width < 360;

    final horizontalPadding = width * 0.04;
    final verticalPadding = height * 0.02;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pengajuan Surat",
            style: TextStyle(
              fontSize: isSmall ? 14 : 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: verticalPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statusItem('Menunggu persetujuan', '20', isSmall),
              Container(
                width: 1,
                height: height * 0.04,
                color: Colors.grey[300],
              ),
              _statusItem('Selesai', '20', isSmall),
            ],
          ),
        ],
      ),
    );
  }

  Widget pengajuan() {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;
    final horizontalPadding = width * 0.04;
    final verticalPadding = height * 0.02;
    final contentPadding = width * 0.05;
    return Container(
      width: double.infinity, // agar container selebar layar
      padding: EdgeInsets.all(contentPadding),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          dataModel == null
              ? const Center(child: CircularProgressIndicator())
              : Wrap(
                  alignment: WrapAlignment.start,
                  spacing: width * 0.02,
                  runSpacing: height * 0.01,
                  children: [
                    ...dataModel!.surat.map(
                      (item) => _suratButton(context, item, Colors.blue, width),
                    ),
                    _lihatSemuaButton(context, width),
                  ],
                ),
        ],
      ),
    );
  }

  Widget berita() {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;
    final horizontalPadding = width * 0.04;
    final verticalPadding = height * 0.02;
    final isSmall = width < 360;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(width * 0.04),
      decoration: _boxDecoration(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Text(
              "Berita & Peristiwa Badean",
              style: TextStyle(
                fontSize: isSmall ? 14 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailBerita(),
                            ),
                          );
                        },
                        dense: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                        leading: Image.asset(
                          'assets/images/coba.png',
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.image_not_supported,
                                size: 40);
                          },
                        ),
                        title: Text(
                          item.judul,
                          maxLines: 2, // Set maxLines to 2 for 2-line text
                          overflow: TextOverflow
                              .ellipsis, // Add ellipsis for overflow text
                          style: TextStyle(fontSize: isSmall ? 12 : 14),
                        ),
                        subtitle: const Text('18 April 2025'),
                      ),
                      const Divider(
                          height: 1), // Garis pemisah antar berita (opsional)
                    ],
                  );
                }).toList(),
              ),
      ]),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 5,
          offset: Offset(0, 2),
        ),
      ],
    );
  }

  Widget _statusItem(String title, String count, bool isSmall) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isSmall ? 16 : 18,
            color: lightColorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            color: Colors.black54,
            fontSize: isSmall ? 11 : 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _suratButton(
      BuildContext context, Surat item, Color color, double width) {
    return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PengajuanSuratPage(namaSurat: item.nama_surat)),
            );
          },
          child: Column(
            children: [
              CircleAvatar(
                radius: width * 0.06,
                backgroundColor: color,
                child: const Icon(Icons.mail_rounded, color: Colors.white),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: width * 0.2,
                child: Text(
                  item.nama_surat,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _lihatSemuaButton(BuildContext context, double width) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ListSurat()));
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: width * 0.06,
            backgroundColor: Colors.grey.shade300,
            child: const Icon(Icons.apps_rounded, color: Colors.black),
          ),
          const SizedBox(height: 8),
          const Text("Lihat Semua", style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
