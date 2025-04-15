import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final Widget? child;

  const CustomScaffold({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background Gradient
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF052158), // Biru tua
                  Color(0xFF0A74DA), // Biru terang
                ],
              ),
            ),
          ),

          // Tombol Back (Panah)

          // Logo dan Judul di atas
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Judul
                Text(
                  "Sibadean", // Anda masih bisa menampilkan judul statis di sini
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                // Logo
                Image.asset(
                  'assets/images/logo.png', // Ganti dengan path logo
                  width: 50,
                  height: 50,
                  // Transparan biar menyatu
                ),
              ],
            ),
          ),

          // Ikon Dekoratif (misalnya ikon surat)
          Positioned(
            bottom: 100,
            right: 30,
            child: Icon(
              Icons.email_rounded,
              size: 100,
              color: Colors.white.withOpacity(0.2),
            ),
          ),

          // Konten utama
          SafeArea(
            child: child!,
          ),
        ],
      ),
    );
  }
}
