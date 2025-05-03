import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sibadeanmob_v2_fix/methods/api.dart';
import 'package:sibadeanmob_v2_fix/views/auth/login.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/profiles/tentang_apk.dart';
import 'informasi_diri.dart';
import 'ganti_email.dart';
import 'ganti_password.dart';

class ProfilePage extends StatefulWidget {
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
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('user_id');
      await preferences.remove('nik');
      await preferences.remove('token');

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
      backgroundColor: Colors.blue.shade900,
      body: Column(
        children: [
          const SizedBox(height: 60),
          // Foto Profil dan Nama
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/profile.png'),
          ),
          const SizedBox(height: 10),
          Text(
            _nameController.text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _nikController.text,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 30),

          // Card Menu
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 3,
                    child: Column(
                      children: [
                        buildMenuItem(
                          icon: Icons.person_outline,
                          title: 'Informasi Diri',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InformasiDiriPage()),
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
                          icon: Icons.lock_outline,
                          title: 'Ganti Password',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GantiPasswordPage()),
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
                ],
              ),
            ),
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
