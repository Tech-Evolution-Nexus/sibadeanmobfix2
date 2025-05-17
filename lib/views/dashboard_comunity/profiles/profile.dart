import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sibadeanmob_v2_fix/methods/api.dart';
import 'package:sibadeanmob_v2_fix/views/auth/login.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/profiles/tentang_apk.dart';
import 'informasi_diri.dart';
import 'ganti_email.dart';
import 'ganti_password.dart';
import 'ganti_noHp.dart';
import 'package:sibadeanmob_v2_fix/helper/database.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String nik = "";
  String nama_lengkap = "";
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    final userList = await DatabaseHelper().getUser();

    if (userList.isNotEmpty) {
      setState(() {
        nik = userList.first.nik;
        nama_lengkap = userList.first.nama_lengkap;
      });
    }
  }

  void logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (shouldLogout != true) return;

    try {
      final response = await API().logout();
      print("Response Logout: $response");

      if (response?.statusCode == 200) {
        print("Logout berhasil, hapus user...");
        await DatabaseHelper().deleteUser();

        if (!context.mounted) return;
        context.go('/login');
      } else {
        final code = response?.statusCode;
        final message = response?.statusMessage ?? 'Tidak diketahui';
        print("Logout gagal. Status: $code, Pesan: $message");
        print("Body: ${response?.data}");

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Logout gagal: $message')),
          );
        }
      }
    } catch (e) {
      print("Error saat logout: $e");

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Terjadi kesalahan saat logout')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Stack(
            children: [
              Container(
                height: 320,
                decoration: BoxDecoration(
                  color: Color(0xFF052158),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(12), // Radius hanya bagian bawah
                  ),
                ),
              ),
              Column(
                children: [
                  Gap(60),
                  Column(
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('assets/images/6.jpg'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          nama_lengkap,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Center(
                        child: Text(
                          nik,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gap(30),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Card(
                          color: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: Colors.black26,
                              width: .2,
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            children: [
                              buildMenuItem(
                                icon: Icons.person_outline,
                                title: 'Informasi Diri',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => InformasiDiriPage(),
                                    ),
                                  );
                                },
                              ),
                              buildDivider(),
                              buildMenuItem(
                                icon: Icons.email_outlined,
                                title: 'Ganti Email',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => GantiEmailPage()),
                                  );
                                },
                              ),
                              buildDivider(),
                              buildMenuItem(
                                icon: Icons.phone_android_outlined,
                                title: 'Ganti Nomor HP',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => GantiNoHpPage()),
                                  );
                                },
                              ),
                              buildDivider(),
                              buildMenuItem(
                                icon: Icons.lock_outline,
                                title: 'Ganti Password',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            GantiPasswordPage()),
                                  );
                                },
                              ),
                              buildDivider(),
                              buildMenuItem(
                                icon: Icons.info_outline,
                                title: 'Tentang',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TentangPage()),
                                  );
                                },
                              ),
                              buildDivider(),
                              buildMenuItem(
                                icon: Icons.logout,
                                title: 'Keluar',
                                iconColor: Colors.red,
                                onTap: logout,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildMenuItem({
    required IconData icon,
    required String title,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Colors.blue.shade900),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 16,
      endIndent: 16,
    );
  }
}
