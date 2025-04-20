import 'dart:convert';
import 'package:flutter/material.dart';
import '../../methods/api.dart';
import 'login.dart';
import '../../widgets/costum_scaffold1.dart';
import '../../widgets/costum_texfield.dart';

class Aktivasi extends StatefulWidget {
  final String nik; // Menerima NIK dari halaman sebelumnya

  const Aktivasi({super.key, required this.nik});

  @override
  State<Aktivasi> createState() => _AktivasiState();
}

class _AktivasiState extends State<Aktivasi> {
  final TextEditingController codeController = TextEditingController();
  bool _isLoading = false; // Indikator loading

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
    if (codeController.text.isEmpty) {
      _showSnackBar("Masukkan kode aktivasi!", isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await API().aktivasiAkun(nik: widget.nik);
      // final responseData = jsonDecode(response.body);

      // print("Respon Aktivasi: $responseData"); // Debugging

      // if (response.statusCode == 200 && responseData['status'] == 'success') {
      //   _showAlertDialog(
      //     "Aktivasi Berhasil",
      //     "Akun Anda berhasil diaktivasi. Silakan login.",
      //     onConfirm: () {
      //       Navigator.pushAndRemoveUntil(
      //         context,
      //         MaterialPageRoute(builder: (context) => const Login()),
      //         (route) => false,
      //       );
      //     },
      //   );
      // } else {
      //   _showSnackBar(responseData['message'] ?? "Terjadi kesalahan.", isError: true);
      // }
    } catch (e) {
      _showSnackBar("Gagal menghubungi server. Cek koneksi internet Anda.", isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showAlertDialog(String title, String message, {VoidCallback? onConfirm}) {
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
              "Aktivasi Akun",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              "Masukkan kode aktivasi yang telah dikirim ke email atau nomor telepon Anda.",
              style: TextStyle(fontSize: 16, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            CustomTextField(
              labelText: "Kode Aktivasi",
              hintText: "Masukkan kode aktivasi",
              controller: codeController,
              keyboardType: TextInputType.number,
              prefixIcon: Icons.vpn_key,
              validator: (value) => value!.isEmpty ? 'Masukkan kode aktivasi Anda' : null,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : aktivasiAkun,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Aktivasi Akun"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
