import 'dart:convert';
import 'package:flutter/material.dart';
import '../../methods/api.dart';
import '../../widgets/costum_button.dart';
import '../../widgets/costum_scaffold1.dart';
import 'register.dart';
import 'aktivasi.dart';
import '../../widgets/costum_texfield.dart';

class Verifikasi extends StatefulWidget {
  const Verifikasi({super.key});

  @override
  State<Verifikasi> createState() => _VerifikasiState();
}

class _VerifikasiState extends State<Verifikasi> {
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
      final response =
          await API().postRequest(route: "/verifikasi", data: {"nik": nik});

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
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
    return CustomScaffold(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Verifikasi NIK Anda",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              "Masukkan Nomor Induk Kependudukan (NIK) untuk memverifikasi apakah Anda sudah terdaftar atau belum.",
              style: TextStyle(fontSize: 16, color: Colors.white70),
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
              validator: (value) => value!.isEmpty ? 'Masukkan NIK Anda' : null,
            ),
            const SizedBox(height: 20),

            // 🔹 Tombol Verifikasi
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: isLoading ? 'Memverifikasi...' : 'Verifikasi',
                onPressed: isLoading ? () {} : verifikasiNIK,
                // Disable tombol saat loading
              ),
            ),
          ],
        ),
      ),
    );
  }
}
