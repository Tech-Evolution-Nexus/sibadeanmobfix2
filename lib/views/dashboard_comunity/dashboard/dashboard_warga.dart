import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../theme/theme.dart';
import '../../../services/berita_service.dart';
import '../pengajuan/list_surat.dart';
import '../pengajuan/pengajuan_surat.dart';
import '../pengajuan/riwayat_pengajuan.dart';
import '../profiles/profile.dart'
    show ProfilePage;

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
  // ignore: library_private_types_in_public_api
  _DashboardContentState createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  String nama = "User";
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
      foto = prefs.getString('foto') ?? "";
    });
  }

  Future<void> fetchBerita() async {
    try {
      print("Fetching berita..."); // Debug
      List<String> beritaData = await BeritaService().fetchBerita();
      print("Berita Diterima: $beritaData"); // Debug

      setState(() {
        berita = beritaData;
        isLoading = false;
      });
    } catch (e) {
      print("Error mengambil berita: $e"); // Debug
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header dengan Gradient dan Melengkung di Bawah
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

        // Slider Berita dengan Shadow
        Container(
          height: 150,
          margin: EdgeInsets.symmetric(vertical: 10),
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : berita.isEmpty
                  ? Center(
                      child: Text(
                        "Tidak ada berita tersedia",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  : PageView.builder(
                      itemCount: berita.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(color: Colors.black26, blurRadius: 6)
                            ],
                          ),
                          child: Card(
                            color: Colors.white,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  berita[index],
                                  style: TextStyle(
                                      color: lightColorScheme.primary,
                                      fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
        ),

        // Daftar Surat dengan Desain Modern
        Expanded(
          child: GridView.count(
            padding: EdgeInsets.all(10),
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            children: [
              suratCard("Surat KTP", context),
              suratCard("Surat Domisili", context),
              suratCard("Surat Nikah", context),
              suratCard("Surat Kelahiran", context),
              suratCard("Surat Kematian", context),
              suratCard("Surat Usaha", context),
            ],
          ),
        ),

        // Tombol Lihat Semua Surat
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ListSurat()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: lightColorScheme.primary,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            child: Text(
              "Lihat Semua Surat",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget suratCard(String title, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PengajuanSuratPage(
              namaSurat: title,
              jenisSurat: '',
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.article_rounded,
                  size: 40, color: lightColorScheme.primary),
              SizedBox(height: 8),
              Text(title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
