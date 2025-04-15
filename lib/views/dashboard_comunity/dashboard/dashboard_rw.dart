import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../theme/theme.dart';
import '../profiles/profile.dart';
import '../riwayatsurat/riwayat_surat_rw.dart';
import '../../../services/berita_service.dart';

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
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.history_rounded), label: "Riwayat"),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: "Profil"),
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
  String nama = "RW";
  String foto = "";
  List<String> berita = [];
  int totalSuratMasuk = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserData();
    fetchBerita();
    fetchTotalSurat();
  }

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nama = prefs.getString('nama') ?? "RW";
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

  Future<void> fetchTotalSurat() async {
    // Simulasi API mengambil total surat masuk
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      totalSuratMasuk = 20; // Gantilah dengan data dari API
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header dengan Nama RW dan Foto Profil
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [lightColorScheme.primary, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Selamat Datang, $nama!",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              CircleAvatar(
                radius: 25,
                backgroundImage: foto.isNotEmpty
                    ? NetworkImage(foto)
                    : AssetImage('assets/images/default_user.png')
                        as ImageProvider,
              ),
            ],
          ),
        ),

        // Card Total Surat Masuk
        Container(
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total Surat Masuk", style: TextStyle(fontSize: 16)),
                  Text("$totalSuratMasuk",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
              Icon(Icons.mail_rounded, size: 40, color: Colors.blue),
            ],
          ),
        ),

        // Berita
        Container(
          height: 150,
          margin: EdgeInsets.symmetric(vertical: 10),
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : berita.isEmpty
                  ? Center(child: Text("Tidak ada berita"))
                  : PageView.builder(
                      itemCount: berita.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
                          ),
                          child: Card(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  berita[index],
                                  style: TextStyle(color: Colors.black, fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}
