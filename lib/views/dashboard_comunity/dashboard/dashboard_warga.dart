import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/pengajuan/riwayat_pengajuan.dart';
import '../../../theme/theme.dart';
import '../../../services/berita_service.dart';
import '../pengajuan/list_surat.dart';
import '../pengajuan/pengajuan_surat.dart';
import '../profiles/profile.dart' show ProfilePage;

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;
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
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.mail_rounded), label: "Pengajuan"),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "Profil"),
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
  List<String> berita = [];
  bool isLoading = true;

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
      List<String> beritaData = await BeritaService().fetchBerita();
      setState(() {
        berita = beritaData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  lightColorScheme.primary,
                  const Color.fromARGB(255, 25, 44, 155)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: foto.isNotEmpty
                          ? NetworkImage(foto)
                          : AssetImage('assets/images/default_user.png') as ImageProvider,
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nama,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          nik,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Icon(Icons.notifications, color: Colors.white),
                  ],
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _statusItem('Menunggu persetujuan', '20'),
                      Container(width: 1, height: 35, color: Colors.grey[300]),
                      _statusItem('Selesai', '20'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Daftar Jenis Surat
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Pengajuan Surat",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 20,
                    runSpacing: 20,
                    children: [
                      _suratButton(context, 'SKTM', Colors.green),
                      _suratButton(context, 'Surat Keterangan Usaha', Colors.yellow[700]!),
                      _suratButton(context, 'Surat Izin Usaha', Colors.blue),
                      _suratButton(context, 'Surat Ganti Nama', Colors.pink),
                      _suratButton(context, 'Surat Keterangan Domisili', Colors.teal),
                      _suratButton(context, 'Surat Keterangan Pindah', Colors.orange),
                      _suratButton(context, 'Surat Keterangan Kematian', Colors.red),
                      _suratButton(context, 'Surat Keterangan Lahir', Colors.purple),
                      _lihatSemuaButton(context),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Berita
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Berita & Peristiwa Badean",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios, size: 14),
                    ],
                  ),
                  SizedBox(height: 10),
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Column(
                          children: berita.map((item) {
                            return Card(
                              child: ListTile(
                                leading: Image.asset(
                                  'assets/images/berita.png',
                                  width: 40,
                                ),
                                title: Text(
                                  item,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text('18 April 2025'),
                              ),
                            );
                          }).toList(),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusItem(String title, String count) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: lightColorScheme.primary,
          ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            color: Colors.black54,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _suratButton(BuildContext context, String title, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PengajuanSuratPage(namaSurat: title),
          ),
        );
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(Icons.mail_rounded, color: Colors.white),
          ),
          SizedBox(height: 8),
          SizedBox(
            width: 70,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _lihatSemuaButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ListSurat()),
        );
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey.shade300,
            child: Icon(Icons.apps_rounded, color: Colors.black),
          ),
          SizedBox(height: 8),
          Text("Lihat Semua", style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
