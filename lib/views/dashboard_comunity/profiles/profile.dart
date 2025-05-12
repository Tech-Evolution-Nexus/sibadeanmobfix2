import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
  final TextEditingController _nameController =
      TextEditingController(text: "Muhammad Nor Kholit");
  final TextEditingController _nikController =
      TextEditingController(text: "327303030982");

  void logout() async {
  final response = await API().logout();

  if (response.statusCode == 200) {
    // Hapus semua data user dari tabel 'user'
    await DatabaseHelper().deleteUser();

    // Navigasi ke halaman login
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
      (route) => false,
    );
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
                          _nameController.text,
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
                          _nikController.text,
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
