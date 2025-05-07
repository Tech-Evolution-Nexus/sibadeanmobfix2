import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../methods/api.dart';
import '../../dashboard_comunity/dashboard/dashboard_warga.dart';

class GantiPasswordPage extends StatefulWidget {
  const GantiPasswordPage({super.key});

  @override
  State<GantiPasswordPage> createState() => _GantiPasswordPageState();
}

void _showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}


class _GantiPasswordPageState extends State<GantiPasswordPage> {
  final passwordController = TextEditingController();
  final newPassController = TextEditingController();
  final confirmController = TextEditingController();

  Future<void> chgPass(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final nik = preferences.getString('nik') ?? '';
    final currentPass = passwordController.text.trim();
    final newPass = newPassController.text.trim();
    final confPass = confirmController.text.trim();

    print(
        'DEBUG: newPass="$newPass" (${newPass.length}), confPass="$confPass" (${confPass.length})');

if (newPass.isEmpty || confPass.isEmpty) {
      _showSnackBar(context, 'Kolom tidak boleh kosong.');
      return;
    }

    if (newPass.length < 6) {
      _showSnackBar(context, 'Password harus terdiri dari minimal 6 karakter.');
      return;
    }

    if (newPass != confPass) {
      _showSnackBar(context, 'Konfirmasi password tidak sesuai.');
      return;
    }

// Proceed with API call


    try {
      final response = await API().chgPass(
          nik: nik,
          password: currentPass,
          newPass: newPass,
          confPass: confPass);
      print(response.data);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(response.data['message'] ?? 'Password berhasil diubah')),
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => DashboardPage()),
        );
      } else {
        final errorMessage =
            response.data['message'] ?? 'Gagal mengubah password';
        print("Gagal: $errorMessage");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: $errorMessage')),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: ${e.toString()}')),
      );
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ganti Password")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                "Harap masukkan Kata Sandi baru untuk\nmemperbarui informasi Anda"),
            const SizedBox(height: 20),
            TextField(
              controller: newPassController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Kata Sandi",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: confirmController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Konfirmasi Kata Sandi",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => chgPass(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo[900],
                ),
                child: const Text("Ubah Password"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
