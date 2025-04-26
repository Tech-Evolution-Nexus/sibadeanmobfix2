import 'package:flutter/material.dart';

class InformasiDiriPage extends StatelessWidget {
  const InformasiDiriPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              // Background biru
              Container(
                height: 200,
                width: double.infinity,
                color: Colors.indigo[900],
                child: const Center(
                  child: Text(
                    'Informasi Diri',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              // Card + Foto Profil
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Column(
                  children: [
                    // Foto Profil
                    const Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 46,
                          backgroundImage: AssetImage('assets/user_photo.jpg'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Nama
                              const Center(
                                child: Text(
                                  "Muhammad Nor Kholit",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Email & NIK
                              const Center(
                                child: Text("mnorkholit7@gmail.com | 357303030982"),
                              ),
                              const SizedBox(height: 16),
                              // Detail Profesi, Telepon, Agama
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  DetailItem(icon: Icons.work, label: "Guru"),
                                  DetailItem(icon: Icons.phone, label: "081233882834"),
                                  DetailItem(icon: Icons.mosque, label: "Islam"),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "Alamat",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                "Jl. Melati No. 123 RT 04 RW 05,\nKel. Sukamaju, Kec. Cimanggis,\nKota Depok, Jawa Barat 16451",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Tombol kembali
              Positioned(
                top: 10,
                left: 16,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
