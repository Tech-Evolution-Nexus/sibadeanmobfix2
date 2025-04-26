import 'package:flutter/material.dart';

class TentangPage extends StatelessWidget {
  const TentangPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackButton(), title: const Text("Tentang")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'assets/images/logo.png', // Ganti dengan logo aplikasi kamu
              width: 100,
              height: 100,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "E-Surat Badean",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Text(
              "Silakan perbarui informasi akun Anda di bawah ini. Pastikan data yang Anda masukkan sudah benar dan sesuai.",
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text("2.0.0", style: TextStyle(color: Colors.grey)),
          )
        ],
      ),
    );
  }
}
