import 'package:flutter/material.dart';

import 'package:badges/badges.dart' as badges;
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sibadeanmob_v2_fix/methods/api.dart';
import 'package:sibadeanmob_v2_fix/methods/auth.dart';
import 'package:sibadeanmob_v2_fix/models/BeritaSuratModel.dart';
import 'package:sibadeanmob_v2_fix/models/SuratKeluar.dart';
import 'package:sibadeanmob_v2_fix/models/SuratModel.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/berita/BeritaItem.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/kartu_keluarga/list_kartu_keluarga.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/pengajuan_surat/list_surat.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/surat_keluar/notifikasi_suratkeluar_page.dart';

import '../../../theme/theme.dart';
import '../profiles/profile.dart';
import '../penyetujuan_surat/riwayat_surat_rt_rw.dart';

class DashboardRW extends StatefulWidget {
  final int initialIndex;
  const DashboardRW({super.key, this.initialIndex = 0});
  @override
  _DashboardRWState createState() => _DashboardRWState();
}

class HomeRW extends StatefulWidget {
  const HomeRW({super.key});

  @override
  _HomeRWState createState() => _HomeRWState();
}

class _DashboardRWState extends State<DashboardRW> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    HomeRW(),
    RiwayatSuratRTRW(),
    ProfilePage(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentIndex = widget.initialIndex;
  }

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
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_rounded),
            label: "Riwayat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: "Profil",
          ),
        ],
      ),
    );
  }
}

class _HomeRWState extends State<HomeRW> {
  String nama = "User";
  String nik = "";
  String foto = "";
  bool isLoading = true;
  BeritaSuratModel? dataModel;
  int jumlahNotifikasi = 0;

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
        InkWell(
          onTap: () {
            setState(() {
              _DashboardRWState? state =
                  context.findAncestorStateOfType<_DashboardRWState>();
              if (state != null) {
                state.setState(() {
                  state._currentIndex = 1;
                });
              }
            });
          },
          child: Row(
            children: [
              Text(
                "Berita & Peristiwa Badean",
                style: TextStyle(
                  fontSize: isSmall ? 14 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 12,
        ),
        MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView.builder(
            itemCount: dataModel!.berita.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return BeritaItem(berita: dataModel!.berita[index]);
            },
          ),
        )
      ]),
    );
  }

  void fetchNotifikasi() async {
    try {
      List<SuratKeluar> data = await API().getSuratKeluar();
      setState(() {
        jumlahNotifikasi = data.length;
      });
    } catch (e) {
      print("Gagal memuat notifikasi: $e");
    }
  }

  void fetchJumlahSuratKeluar() async {
    final suratList = await API().getSuratKeluar();
    final prefs = await SharedPreferences.getInstance();
    List<String> dibacaIds = prefs.getStringList('dibaca_surat') ?? [];

    // hanya hitung surat yang belum dibaca
    final belumDibaca = suratList
        .where(
          (surat) => !dibacaIds.contains(surat.id.toString()),
        )
        .toList();

    setState(() {
      jumlahNotifikasi = belumDibaca.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;
    final isSmall = width < 360;

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            padding: const EdgeInsets.all(0),
            children: [
              Stack(
                children: [
                  buildBackground(),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, top: 60),
                    child: Column(
                      children: [
                        const Gap(16),
                        buildHeader(),
                        const Gap(16),
                        cardHero(),
                        const Gap(16),
                        berita(),
                        const Gap(16),
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(16),
            ],
          );
  }

  Widget buildBackground() {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    return Container(
      height: width * 1.5,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary,
            Colors.white,
          ],
          stops: [0.0, 0.3, 0.6, 1.0],
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
              : const AssetImage('assets/images/6.jpg') as ImageProvider,
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
        // Ganti icon notifikasi dengan badge
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NotifikasiSuratKeluarPage(
                  onSuratDibaca:
                      fetchJumlahSuratKeluar, // refresh badge setelah dibuka
                ),
              ),
            );
          },
          child: badges.Badge(
            showBadge: jumlahNotifikasi > 0,
            badgeContent: Text(
              '$jumlahNotifikasi',
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
            badgeStyle: const badges.BadgeStyle(
              badgeColor: Colors.red,
              elevation: 0,
              padding: EdgeInsets.all(6),
            ),
            position: badges.BadgePosition.topEnd(top: -4, end: -4),
            child: const Icon(Icons.notifications, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget cardHero() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween, // bisa dihapus karena Expanded akan mengatur lebar
            children: [
              Expanded(
                flex: 5,
                child: _statusItem(
                    'Menunggu persetujuan',
                    dataModel!.dash.totalMenungguPersetujuan.toString(),
                    isSmall),
              ),
              Expanded(
                flex: 3,
                child: _statusItem(
                    'Selesai',
                    dataModel!.dash.totalPersetujuanSelesai.toString(),
                    isSmall),
              ),
            ],
          ),
          SizedBox(
            height: 24,
          ),
          Divider(
            height: 1,
          ),
          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                // crossAxisCount: (width / 100).floor(),
                crossAxisSpacing: width * 0,
                mainAxisSpacing: height * 0,
                childAspectRatio: 1.0,
              ),
              itemCount: dataModel!.surat.length + 1,
              itemBuilder: (context, index) {
                if (index < dataModel!.surat.length) {
                  final item = dataModel!.surat[index];
                  // final color = colors[index % colors.length];
                  return _suratButton(context, item, width);
                } else {
                  return _lihatSemuaButton(context, width);
                }
              },
            ),
          )
        ],
      ),
    );
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

  Future<void> getUserData() async {
    final user = await Auth.user();
    setState(() {
      nama = user['nama'] ?? "User";
      nik = user['nik'] ?? "NIK tidak ditemukan";
      foto = user['foto'] ?? "";
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    fetchBerita();
    fetchJumlahSuratKeluar();
    fetchNotifikasi();
  }

  Widget pengajuan() {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;
    final contentPadding = width * 0.0;
    List<Color> colors = [
      Color(0xFF06A819),
      Color(0xFF2196F3),
      Color(0xFFFFC107),
      Color(0xFFFF5722),
      Color(0xFF9C27B0),
      Color(0xFF00BCD4),
    ];
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(contentPadding),
      decoration: _boxDecoration(),
      child: dataModel == null
          ? const Center(child: CircularProgressIndicator())
          : MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  // crossAxisCount: (width / 100).floor(),
                  crossAxisSpacing: width * 0,
                  mainAxisSpacing: height * 0,
                  childAspectRatio: 1.0,
                ),
                itemCount: dataModel!.surat.length + 1,
                itemBuilder: (context, index) {
                  if (index < dataModel!.surat.length) {
                    final item = dataModel!.surat[index];
                    // final color = colors[index % colors.length];
                    return _suratButton(context, item, width);
                  } else {
                    return _lihatSemuaButton(context, width);
                  }
                },
              ),
            ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 5,
          offset: Offset(0, 2),
        ),
      ],
    );
  }

  Widget _lihatSemuaButton(BuildContext context, double width) {
    return Container(
      child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  enableDrag: true,
                  showDragHandle: true,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(32))),
                  context: context,
                  builder: (BuildContext context) =>
                      SizedBox(width: double.infinity, child: ListSurat()));
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => ListSurat()),
              // );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: width * 0.05,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(Icons.grid_view_outlined, color: Colors.white),
                ),
                const SizedBox(height: 1),
                Text("Lihat Semua",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.primary)),
              ],
            ),
          )),
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
            color: Theme.of(context).colorScheme.primary,
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

  Widget _suratButton(BuildContext context, Surat item, double width) {
    String singkatNamaSuratLower = item.singkatanNamaSurat.toLowerCase();
    return Container(
      child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DaftarAnggotaKeluargaView(
                        idsurat: item.id, namasurat: item.nama_surat)),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: width * 0.05,
                  backgroundColor: Colors.white,
                  child: Icon(
                    singkatNamaSuratLower == "skck"
                        ? Icons.local_police_outlined
                        : (singkatNamaSuratLower == "sku"
                            ? Icons.storefront
                            : Icons.interests_outlined),
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  item.singkatanNamaSurat,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
          )),
    );
  }
}
