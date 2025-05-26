import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import "package:gap/gap.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sibadeanmob_v2_fix/helper/database.dart';
import 'package:sibadeanmob_v2_fix/models/BeritaSuratModel.dart';
import 'package:sibadeanmob_v2_fix/models/PengajuanModel.dart';
import 'package:sibadeanmob_v2_fix/models/SuratModel.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/berita/BeritaItem.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/berita/list_berita.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/kartu_keluarga/list_kartu_keluarga.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/pengajuan_surat/riwayat_pengajuan.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/surat_keluar/notifikasi_suratkeluar_page.dart';

import '/methods/api.dart';
import '../../../widgets/BottomBar.dart';
import '../pengajuan_surat/list_surat.dart';
import '../profiles/profile.dart' show ProfilePage;

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0; //navigasi butoon
  final List<Widget> _pages = [
    const DashboardContent(key: PageStorageKey('Dashboard')),
    ListBerita(),
    PengajuanPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class DashboardContent extends StatefulWidget {
  const DashboardContent({super.key});

  @override
  _DashboardContentState createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  String nama = "User";
  String nik = "";
  String foto = "";
  bool isLoading = true;
  BeritaSuratModel? dataModel;
  int jumlahNotifikasi =
      0; //umlah surat keluar yang belum dibaca, tampil sebagai badge di ikon notifika
  List<PengajuanSurat> pengajuanMenunggu = [];
  List<PengajuanSurat> pengajuanSelesai = [];
  bool isFetched = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isFetched) {
      getUserData();
      fetchDash();
      fetchJumlahSuratKeluar();
      fetchData();
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

  Future<void> getUserData() async {
    final userList = await DatabaseHelper().getUser();
    //  final userList = await DatabaseHelper().getUser();
    if (userList.isNotEmpty) {
      final user = userList.first;
      setState(() {
        nama = user.nama_lengkap ?? "User";
        nik = user.nik ?? "NIK tidak ditemukan";
        foto = user.avatar ?? ""; // pastikan model punya field `foto`
      });
    } else {
      setState(() {
        nama = "User";
        nik = "NIK tidak ditemukan";
        foto = "";
      });
    }
  }

  Future<void> fetchDash() async {
    try {
      var response = await API().getdatadashboard();
      // print(response.data['data']);
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

  Future<void> fetchData() async {
    try {
      // print("test");
      var response = await API().getRiwayatPengajuanMasyarakat();
      print(response.data["data"]);
      if (response.statusCode == 200) {
        setState(() {
          pengajuanMenunggu =
              (response.data["data"]["pengajuanMenunggu"] as List)
                  .map((item) => PengajuanSurat.fromJson(item))
                  .toList();
          pengajuanSelesai = (response.data["data"]["pengajuanSelesai"] as List)
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
  // void fetchNotifikasi() async {
  //   try {
  //     List<SuratKeluar> data = await API().getSuratKeluar();
  //     setState(() {
  //       jumlahNotifikasi = data.length;
  //     });
  //   } catch (e) {
  //     print("Gagal memuat notifikasi: $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;
    final isSmall = width < 360;
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () async {
              getUserData();
              fetchDash();
              fetchJumlahSuratKeluar();
            },
            child: ListView(
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
                          const Gap(32),
                          cardhero(),
                          const Gap(16),
                          berita(),
                        ],
                      ),
                    ),
                  ],
                ),
                const Gap(16),
              ],
            ),
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
        // color:  Theme.of(context).colorScheme.primary,
        // borderRadius: const BorderRadius.only(
        //   bottomLeft: Radius.circular(12),
        //   bottomRight: Radius.circular(12),
        // ),
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
          backgroundImage: NetworkImage(
            (foto != null && foto.trim().isNotEmpty)
                ? foto
                : 'https://ui-avatars.com/api/?name=${nama}&background=fff&color=052158', // Gambar default online
          ),
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
              padding: EdgeInsets.all(4),
            ),
            position: badges.BadgePosition.topEnd(top: -4, end: -1),
            child: const Icon(Icons.notifications, color: Colors.white),
          ),
        ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween, // bisa dihapus karena Expanded akan mengatur lebar
            children: [
              Expanded(
                flex: 5,
                child: _statusItem(
                    'Menunggu persetujuan',
                    dataModel!.dash?.totalMenungguPersetujuan.toString() ?? "0",
                    isSmall),
              ),
              Expanded(
                flex: 3,
                child: _statusItem(
                    'Selesai',
                    dataModel!.dash?.totalPersetujuanSelesai.toString() ?? "0",
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
              _DashboardPageState? state =
                  context.findAncestorStateOfType<_DashboardPageState>();
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
              return BeritaItem(
                berita: dataModel!.berita[index],
                variant: "vertical",
              );
            },
          ),
        )
      ]),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: Colors.black54,
        width: 0.2,
      ),
    );
  }

  Widget _statusItem(String title, String count, bool isSmall) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              count,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isSmall ? 18 : 20,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              "surat",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        )
      ],
    );
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

  Widget _lihatSemuaButton(BuildContext context, double width) {
    return Container(
      child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  enableDrag: true,
                  showDragHandle: true,
                  //   isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(32))),
                  context: context,
                  builder: (BuildContext context) => Container(
                      constraints:
                          BoxConstraints(minHeight: 500, maxHeight: 600),
                      child: SizedBox(
                          width: double.infinity, child: ListSurat())));
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
}
