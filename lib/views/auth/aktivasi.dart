import 'dart:convert';
import 'package:flutter/material.dart';
import '../../methods/api.dart';
import 'login.dart';
import '../../widgets/costum_texfield.dart';

class Aktivasi extends StatefulWidget {
  final String nik; // Menerima NIK dari halaman sebelumnya

  const Aktivasi({super.key, required this.nik});

  @override
  State<Aktivasi> createState() => _AktivasiState();
}

class _AktivasiState extends State<Aktivasi> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void aktivasiAkun() async {
    if (emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        passwordController.text.isEmpty) {
      _showSnackBar("Harap lengkapi semua field!", isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await API().aktivasiAkun(nik: widget.nik);
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        _showAlertDialog(
          "Aktivasi Berhasil",
          "Akun Anda berhasil diaktivasi. Silakan login.",
          onConfirm: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Login()),
              (route) => false,
            );
          },
        );
      } else {
        _showSnackBar(responseData['message'] ?? "Terjadi kesalahan.",
            isError: true);
      }
    } catch (e) {
      _showSnackBar("Gagal menghubungi server. Cek koneksi internet Anda.",
          isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showAlertDialog(String title, String message,
      {VoidCallback? onConfirm}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (onConfirm != null) onConfirm();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          // biar aman dari overflow
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch, // ini kunci tombol full lebar
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 0),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Image.asset(
                  'assets/images/aktivasi.png',
                  height: deviceWidth * 0.5,
                  fit: BoxFit.contain,
                ),
              ),
              const Text(
                "Aktivasi Akun",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0)),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 10),
              const Text(
                "Lengkapi input berikut untuk mengaktivkan akun anda",
                style: TextStyle(
                    fontSize: 16, color: Color.fromARGB(179, 5, 5, 5)),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 30.0),
              CustomTextField(
                labelText: "Email",
                hintText: "Masukkan Email Aktif",
                controller: emailController,
                prefixIcon: Icons.email,
                validator: (value) =>
                    value!.isEmpty ? 'Email tidak boleh kosong' : null,
              ),
              const SizedBox(height: 15),
              CustomTextField(
                labelText: "No HP",
                hintText: "Masukkan Nomor HP",
                controller: phoneController,
                prefixIcon: Icons.phone,
                validator: (value) =>
                    value!.isEmpty ? 'Nomor HP tidak boleh kosong' : null,
              ),
              const SizedBox(height: 15),
              CustomTextField(
                labelText: "Password",
                hintText: "Masukkan Password Baru",
                controller: passwordController,
                prefixIcon: Icons.lock,
                validator: (value) =>
                    value!.isEmpty ? 'Password tidak boleh kosong' : null,
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 78, 141),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _isLoading ? null : aktivasiAkun,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Aktivasi Akun",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
