import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sibadeanmob_v2_fix/methods/api.dart';
import 'package:sibadeanmob_v2_fix/models/SuratModel.dart';
import '../../../theme/theme.dart';
import '../../../services/berita_service.dart';
import '../pengajuan/list_surat.dart';
import '../pengajuan/pengajuan_surat.dart';
import '../pengajuan/riwayat_pengajuan.dart';
import '../profiles/profile.dart' show ProfilePage;
import '/models/BeritaSuratModel.dart';

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
  List<String> suratList = [];
  bool isLoading = true;
  BeritaSuratModel? dataModel;
  @override
  void initState() {
    super.initState();
    getdata();

    getUserData();
  }

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nama = prefs.getString('nama') ?? "User";
      foto = prefs.getString('foto') ?? "";
    });
  }

  void getdata() async {
    try {
      var response = await API().getdatadashboard();

      if (response.statusCode == 200) {
        final data = response.data['data'];

        setState(() {
          dataModel = BeritaSuratModel.fromJson(data);
          isLoading = false;
        });
        // print(dataModel?.surat.toString());
      }
    } catch (e) {
      print("Error: $e");
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
                    : AssetImage('assets/images/logo.png') as ImageProvider,
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
              : dataModel!.berita.isEmpty
                  ? Center(
                      child: Text(
                        "Tidak ada berita tersedia",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  : PageView.builder(
                      itemCount: dataModel!.berita.length,
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
                                  dataModel!.berita[index].judul,
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
            children: dataModel!.surat.map((item) {
              return suratCard(item, context);
            }).toList(),
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

  Widget suratCard(Surat surat, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PengajuanSuratPage(
              namaSurat: surat.nama_surat, // atau isi sesuai kebutuhan
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
              Text(
                surat.nama_surat,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
