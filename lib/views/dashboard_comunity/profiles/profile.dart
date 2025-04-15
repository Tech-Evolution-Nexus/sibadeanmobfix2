import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController =
      TextEditingController(text: "User");
  final TextEditingController _emailController =
      TextEditingController(text: "user@email.com");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profil")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar Profile
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/profile.png'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    _nameController.text,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _emailController.text,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Card untuk Edit Profil
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 3,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: "Nama"),
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: "Email"),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text("Simpan Perubahan"),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Menu Pengaturan
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 3,
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.lock, color: Colors.blue),
                    title: Text("Ubah Kata Sandi"),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // TODO: Tambahkan navigasi ke halaman ubah kata sandi
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.notifications, color: Colors.orange),
                    title: Text("Notifikasi"),
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {},
                    ),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.palette, color: Colors.purple),
                    title: Text("Tema Aplikasi"),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // TODO: Tambahkan navigasi ke halaman tema aplikasi
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.help, color: Colors.green),
                    title: Text("Bantuan"),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // TODO: Tambahkan navigasi ke halaman bantuan
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Tombol Logout
            ElevatedButton(
              onPressed: () {
                // TODO: Tambahkan fungsi logout
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text("Keluar", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
