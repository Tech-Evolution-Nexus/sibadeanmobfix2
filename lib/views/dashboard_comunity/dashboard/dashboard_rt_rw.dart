import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sibadeanmob_v2_fix/helper/database.dart';
import 'package:sibadeanmob_v2_fix/methods/api.dart';
import 'package:sibadeanmob_v2_fix/methods/auth.dart';
import 'package:sibadeanmob_v2_fix/models/BeritaSuratModel.dart';
import 'package:sibadeanmob_v2_fix/models/DashModel.dart';
import 'package:sibadeanmob_v2_fix/models/PengajuanModel.dart';
import 'package:sibadeanmob_v2_fix/models/Pengaturan.dart';
import 'package:sibadeanmob_v2_fix/models/SuratKeluar.dart';
import 'package:sibadeanmob_v2_fix/models/SuratModel.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/berita/BeritaItem.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/berita/list_berita.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/formRt/ttd.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/formRt/verivikasi_rt.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/kartu_keluarga/list_kartu_keluarga.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/pengajuan_surat/list_surat.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/pengajuan_surat/riwayat_pengajuan.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/penyetujuan_surat/detail_riwayat.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/profiles/ganti_email.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/profiles/ganti_noHp.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/profiles/ganti_password.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/profiles/tentang_apk.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/surat_keluar/notifikasi_suratkeluar_page.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/verifikasi_masyakat/verifikasi.dart';

import '../penyetujuan_surat/riwayat_surat_rt_rw.dart';
import '../profiles/profile.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DashboardRTRW extends StatefulWidget {
  final int initialIndex;
  const DashboardRTRW({super.key, this.initialIndex = 0});
  @override
  _DashboardRTRWState createState() => _DashboardRTRWState();
}

class HomeRTRW extends StatefulWidget {
  const HomeRTRW({super.key});

  @override
  _HomeRTRWState createState() => _HomeRTRWState();
}

class _DashboardRTRWState extends State<DashboardRTRW> {
  String nama = "User";
  String nik = "";
  String role = "";
  String foto = "";
  int _currentIndex = 0;
  Pengaturan? pengaturan;
  bool isLoading = true;
  final List<Widget> _pages = [
    const HomeRTRW(key: PageStorageKey('DashboardRtRw')),
    HomeRTRW(),
    RiwayatSuratRTRW(),
    VerifikasiPage(
      semuaWarga: [],
    ),
    ProfilePage(
      showAppBar: true,
    ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
    fetchPengaturan();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          pengaturan?.appName ?? "",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context); // tutup drawer
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => ProfilePage(
                                showAppBar: true,
                              )), // ganti dengan halaman profilmu
                    );
                  },
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    padding: EdgeInsets.only(left: 20, bottom: 10, right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                            (foto != null && foto.trim().isNotEmpty)
                                ? foto
                                : 'https://ui-avatars.com/api/?name=${nama}&background=fff&color=052158', // Gambar default online
                          ),
                        ),
                        SizedBox(width: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    nama,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    nik,
                                    style: TextStyle(
                                      color: Colors.grey.shade200,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 16,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),

              // ===== Bagian Menu =====
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildSectionTitle("Layanan Administratif"),
                    _buildDrawerItem(
                      icon: Icons.description_outlined,
                      title: 'Penyetujuan Surat',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => RiwayatSuratRTRW()),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.history,
                      title: 'Riwayat Pengajuan',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => PengajuanPage(showAppBar: true)),
                        );
                      },
                    ),
                    if (role == "rt")
                      _buildDrawerItem(
                        icon: Icons.verified_outlined,
                        title: 'Verifikasi Masyarakat',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => Verifikasi()),
                          );
                        },
                      ),
                    Divider(thickness: 1, color: Colors.grey.shade300),
                    _buildSectionTitle("Profil & Keamanan"),
                    _buildDrawerItem(
                      icon: Icons.description_outlined,
                      title: 'Tanda Tangan',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => TtdPage()),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.email_outlined,
                      title: 'Ganti Email',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => GantiEmailPage()),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.phone_android_outlined,
                      title: 'Ganti No HP',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => GantiNoHpPage()),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.lock_outline,
                      title: 'Ganti Password',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => GantiPasswordPage()),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      icon: Icons.info_outline,
                      title: 'Tentang Aplikasi',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => TentangPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // ===== Logout Button di bawah & tengah =====
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.logout_outlined, color: Colors.white),
                    label:
                        Text("Logout", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: logout,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: _pages[_currentIndex],
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.grey.shade800,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade800,
        ),
      ),
    );
  }

  void logout() async {
    final response = await API().logout();

    if (response.statusCode == 200) {
      // Hapus semua data user dari tabel 'user'
      await DatabaseHelper().deleteUser();
      await FirebaseMessaging.instance.unsubscribeFromTopic('all_users');
      // Navigasi ke halaman login
      context.go('/login');
    }
  }

  Future<void> getUserData() async {
    final user = await Auth.user();
    setState(() {
      nama = user['nama'] ?? "User";
      nik = user['nik'] ?? "NIK tidak ditemukan";
      foto = user['foto'] ?? "";
      role = user['role'] ?? "";
    });
  }

  Future<void> fetchPengaturan() async {
    var res = await Pengaturan.getPengaturan();
    setState(() {
      pengaturan = res;
      isLoading = false;
    });
  }
}

class _HomeRTRWState extends State<HomeRTRW> {
  String nama = "User";
  String nik = "";
  String foto = "";
  int jumlahNotifikasi = 0;
  bool isLoading = true;
  bool isFetced = false;
  BeritaSuratModel? dataModel;
  List<PengajuanSurat> pengajuanMenunggu = [];
  List<PengajuanSurat> pengajuanSelesai = [];
  DashModel? dataModeldash;
  Future<void> fetchBerita() async {
    try {
      var response = await API().getdatadashboard();
      if (response.statusCode == 200) {
        setState(() {
          dataModel = BeritaSuratModel.fromJson(response.data['data']);
          dataModeldash = DashModel.fromJson(response.data['data']["dash"]);
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

  Future<void> fetchData() async {
    try {
      // print("test");
      var response = await API().getRiwayatPengajuanMasyarakat();
      // print(response.data["data"]);
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isFetced) {
      getUserData();
      fetchBerita();
      fetchData();
      fetchJumlahSuratKeluar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () async {
              getUserData(); // Mengambil data pengguna
              fetchBerita(); // Mengambil data berita
              fetchData(); // Mengambil data lainnya
            },
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: [
                Stack(
                  children: [
                    buildBackground(),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 0),
                      child: Column(
                        children: [
                          const Gap(16),
                          buildHeader(),
                          const Gap(16),
                          cardHero(),
                          const Gap(16),
                          cardshhortcutpengajuan(),
                          const Gap(16),
                          berita(),
                          const Gap(16),
                        ],
                      ),
                    ),
                  ],
                ),
                const Gap(16),
                // Menambahkan Surat Masuk di atas Berita
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  // child: suratMasuk(),
                ),
                const Gap(16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                ),
                const Gap(16),
              ],
            ),
          );
  }

  Widget berita() {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final isSmall = width < 360;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(width * 0.04),
      decoration: _boxDecoration(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        InkWell(
          onTap: () {
            setState(() {
              _DashboardRTRWState? state =
                  context.findAncestorStateOfType<_DashboardRTRWState>();
              if (state != null) {
                state.setState(() {
                  state._currentIndex = 1;
                });
              }
            });
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Berita & Peristiwa Badean",
                style: TextStyle(
                  fontSize: isSmall ? 14 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => ListBerita(
                              showAppBar: true,
                            )),
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Lihat Semua"),
                    SizedBox(
                      width: 2,
                    ),
                    Icon(Icons.chevron_right_outlined)
                  ],
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
            itemCount: dataModel?.berita.length ?? 0,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return BeritaItem(
                berita: dataModel!.berita[index],
                variant: "horizontal",
              );
            },
          ),
        )
      ]),
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
              style: const TextStyle(color: Colors.white, fontSize: 8),
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
                    dataModeldash!.totalMenungguPersetujuan.toString(),
                    isSmall),
              ),
              Expanded(
                flex: 3,
                child: _statusItem('Selesai',
                    dataModeldash!.totalPersetujuanSelesai.toString(), isSmall),
              ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          // GestureDetector(
          //   onTap: () {
          //     Navigator.of(context).push(
          //       MaterialPageRoute(builder: (_) => RiwayatSuratRTRW()),
          //     );
          //   },
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     children: [
          //       Text("Lihat Semua"),
          //       SizedBox(
          //         width: 2,
          //       ),
          //       Icon(Icons.chevron_right_outlined)
          //     ],
          //   ),
          // ),
          SizedBox(
            height: 4,
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
              itemCount: (dataModel?.surat.length ?? 0) + 1,
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

  Widget cardshhortcutpengajuan() {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final isSmall = width < 360;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      decoration: _boxDecoration(),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Persetujuan Surat",
                style: TextStyle(
                  fontSize: isSmall ? 14 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => RiwayatSuratRTRW()),
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Lihat Semua"),
                    SizedBox(
                      width: 2,
                    ),
                    Icon(Icons.chevron_right_outlined)
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 4,
          ),
          pengajuanMenunggu == null || pengajuanMenunggu!.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      "Tidak ada pengajuan surat",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: (pengajuanMenunggu?.length ?? 0) < 3
                      ? pengajuanMenunggu?.length
                      : 3,
                  itemBuilder: (context, index) {
                    final surat = pengajuanMenunggu?[index];
                    Color headerColor = getHeaderColor(surat?.status ?? "");

                    return Card(
                      elevation: 0,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        // side: BorderSide(
                        //   color: Colors.black26,
                        //   width: .2,
                        // ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailRiwayat(
                                idPengajuan: surat?.id ?? 0,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: width * 0.05,
                                    backgroundColor: headerColor,
                                    child: const Icon(Icons.mail_rounded,
                                        color: Colors.white),
                                  ),
                                  Gap(12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                surat?.surat.nama_surat ?? "",
                                                overflow: TextOverflow.clip,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              ),
                                            ),
                                            Text(
                                              formatStatus(surat?.status ?? ""),
                                              style: TextStyle(
                                                  color: headerColor,
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                        Gap(6),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                surat?.masyarakat.namaLengkap ??
                                                    "",
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 12),
                                              ),
                                            ),
                                            Text(
                                              surat?.createdAt ?? "",
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 12),
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
                )
        ],
      ),
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
        return "Diterima Rw";
      case 'di_terima_rt':
        return "Diterima Rt";

      default:
        return "Menunggu";
    }
  }
}
