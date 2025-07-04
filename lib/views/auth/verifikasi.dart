import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../methods/api.dart';
import '../../widgets/costum_button.dart';
import '../../widgets/costum_texfield.dart';
import 'register.dart';
import 'aktivasi.dart';

class Verifikasi extends StatefulWidget {
  const Verifikasi({super.key});

  @override
  State<Verifikasi> createState() => _VerifikasiState();
}

class _VerifikasiState extends State<Verifikasi> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nikController = TextEditingController();

  bool isLoading = false;

  // 🔹 Fungsi untuk memverifikasi NIK
  void verifikasiNIK() async {
    String nik = nikController.text.trim();

    // 🔸 Validasi input
    if (nik.isEmpty) {
      _showAlertDialog("Peringatan", "Harap masukkan NIK Anda.");
      return;
    }

    if (nik.length != 16 || !RegExp(r'^[0-9]+$').hasMatch(nik)) {
      _showAlertDialog("Error", "NIK harus terdiri dari 16 digit angka.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await API().verifikasiNIK(nik: nik);
      print("Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final responseData = response.data['data'];
        _showAlertDialog(
          "NIK Ditemukan",
          "NIK ditemukan: ${responseData['masyarakat']['nik']}\nLanjutkan untuk mengaktifkan akun Anda.",
          onConfirm: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Aktivasi(nik: nik)),
            );
          },
        );
      } else if (response.statusCode == 409) {
        _showAlertDialog(
          "Sudah Terdaftar",
          "Akun dengan NIK $nik telah terdaftar.",
          onConfirm: () {
            context.go("/login");
          },
        );
      } else if (response.statusCode == 404) {
        _showAlertDialog(
          "NIK Tidak Ditemukan",
          "Silakan lakukan registrasi terlebih dahulu.",
          onConfirm: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => RegisterScreen(nik: nik)),
            );
          },
        );
      } else {
        _showAlertDialog(
            "Error", "Terjadi kesalahan. Silakan coba lagi nanti.");
      }
    } catch (e) {
      print("Error: $e");
      _showAlertDialog(
        "Kesalahan",
        "Gagal menghubungi server. Periksa koneksi internet Anda.",
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  // 🔹 Dialog notifikasi
  void _showAlertDialog(String title, String message,
      {VoidCallback? onConfirm}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Icon(Icons.info_outline, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[700],
              backgroundColor: Colors.grey[200],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Batal"),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Verifikasi",
            style: TextStyle(color: Colors.black, fontSize: 18)),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 0),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30.0),
                            child: Image.asset(
                              'assets/images/verivikasi.png', // pastikan file gambar sesuai
                              height: deviceWidth * 0.5,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const Text(
                            "Verifikasi NIK Anda",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Lengkapi input berikut untuk melihat status kependudukan Anda.",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 30.0),

                          // 🔹 Input NIK
                          CustomTextField(
                            labelText: "Nomor Induk Kependudukan",
                            hintText: "Masukkan NIK",
                            controller: nikController,
                            keyboardType: TextInputType.number,
                            prefixIcon: Icons.card_membership,
                            maxLength: 16,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Masukkan NIK Anda';
                              } else if (value.length != 16) {
                                return 'NIK harus 16 digit';
                              }
                              return null;
                            },
                          ),

                          const Spacer(),

                          // 🔹 Tombol Verifikasi
                          SizedBox(
                            width: double.infinity,
                            child: CustomButton(
                              text:
                                  isLoading ? 'Memverifikasi...' : 'Verifikasi',
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        verifikasiNIK();
                                      }
                                    },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
