import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../methods/api.dart';
import '../../widgets/costum_button.dart';
import 'register.dart';
import 'aktivasi.dart';
import '../../widgets/costum_texfield.dart';

class Verifikasi extends StatefulWidget {
  const Verifikasi({super.key});

  @override
  State<Verifikasi> createState() => _VerifikasiState();
}

class _VerifikasiState extends State<Verifikasi> {
  final _formdKey = GlobalKey<FormState>();

  final TextEditingController nikController = TextEditingController();
  bool isLoading = false; // Untuk indikator loading

  // 🔹 Fungsi Verifikasi NIK
  void verifikasiNIK() async {
    String nik = nikController.text.trim();

    // 🔸 Validasi Input
    if (nik.isEmpty) {
      _showAlertDialog("Peringatan", "Harap masukkan NIK Anda.");
      return;
    }

    if (nik.length != 16 || !RegExp(r'^[0-9]+$').hasMatch(nik)) {
      _showAlertDialog("Error", "NIK harus 16 digit angka.");
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
          "Verifikasi Berhasil",
          "NIK ditemukan: ${responseData['masyarakat']['nik']}",
          onConfirm: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Aktivasi(nik: nik)),
            );
          },
        );
      } else if (response.statusCode == 409) {
        _showAlertDialog("sudah terdaftar", onConfirm: () {
          context.go("/login");
        }, "Akun Anda Telah Terdaftar");
      } else if (response.statusCode == 404) {
        _showAlertDialog("NIK Tidak Ditemukan", onConfirm: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => RegisterScreen()),
          );
        }, "Silakan lakukan registrasi terlebih dahulu.");
      } else {
        _showAlertDialog("Error", "Terjadi kesalahan. Coba lagi nanti.");
      }
    } catch (e) {
      print("Error: $e");
      _showAlertDialog(
          "Kesalahan", "Gagal menghubungi server. Cek koneksi internet Anda.");
    }

    setState(() {
      isLoading = false;
    });
  }

  // 🔹 Fungsi untuk menampilkan dialog alert
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
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formdKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 0),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    child: Image.asset(
                      'assets/images/verivikasi.png',
                      height: deviceWidth * 0.5,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const Text(
                    "Verifikasi NIK Anda",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0)),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Lengkapi input berikut untuk melihat status keanggotaan kependudukan Anda",
                    style: TextStyle(
                        fontSize: 16, color: Color.fromARGB(179, 5, 5, 5)),
                    textAlign: TextAlign.start,
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
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Masukkan NIK Anda';
                      } else if (value.length != 16) {
                        return 'NIK harus 16 digit';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // 🔹 Tombol Verifikasi
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: isLoading ? 'Memverifikasi...' : 'Verifikasi',
                      onPressed: isLoading
                          ? null
                          : () {
                              if (_formdKey.currentState!.validate()) {
                                verifikasiNIK();
                              }
                            },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
