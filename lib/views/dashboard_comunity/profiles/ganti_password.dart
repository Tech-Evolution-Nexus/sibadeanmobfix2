import 'package:flutter/material.dart';
import 'package:sibadeanmob_v2_fix/widgets/costum_texfield.dart';
import '../../../methods/api.dart';
import '../../dashboard_comunity/dashboard/dashboard_warga.dart';
import 'package:sibadeanmob_v2_fix/helper/database.dart';

class GantiPasswordPage extends StatefulWidget {
  const GantiPasswordPage({super.key});

  @override
  State<GantiPasswordPage> createState() => _GantiPasswordPageState();
}

class _GantiPasswordPageState extends State<GantiPasswordPage> {
  final passwordController = TextEditingController();
  final newPassController = TextEditingController();
  final confirmController = TextEditingController();
  bool _obscurePasswordskrg = true;
  bool _obscurePasswordbaruskrg = true;
  bool _obscurePasswordbaru = true;
  bool _obscurePasswordkonskrg = true;

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> chgPass() async {
    final userList = await DatabaseHelper().getUser();
    final nik = userList.first.nik;

    final currentPass = passwordController.text.trim();
    final newPass = newPassController.text.trim();
    final confPass = confirmController.text.trim();

    if (currentPass.isEmpty || newPass.isEmpty || confPass.isEmpty) {
      _showSnackBar('Semua kolom wajib diisi.');
      return;
    }

    if (newPass.length < 6) {
      _showSnackBar('Password harus minimal 6 karakter.');
      return;
    }

    if (newPass != confPass) {
      _showSnackBar('Konfirmasi password tidak cocok.');
      return;
    }

    try {
      final response = await API().chgPass(
        nik: nik,
        password: currentPass,
        newPass: newPass,
        confPass: confPass,
      );

      if (response.statusCode == 200) {
        _showSnackBar(response.data['message'] ?? 'Password berhasil diubah');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => DashboardPage()),
        );
      } else {
        final errorMessage =
            response.data['message'] ?? 'Gagal mengubah password';
        _showSnackBar('Gagal: $errorMessage');
      }
    } catch (e) {
      _showSnackBar('Terjadi kesalahan: ${e.toString()}');
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    newPassController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ganti Password")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Harap masukkan Kata Sandi baru untuk\nmemperbarui informasi Anda",
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: passwordController,
                obscureText: _obscurePasswordskrg,
                prefixIcon: Icons.lock,
                suffixIcon: _obscurePasswordbaruskrg
                    ? Icons.visibility_off
                    : Icons.visibility,
                onSuffixPressed: () {
                  setState(() {
                    _obscurePasswordbaruskrg = !_obscurePasswordbaruskrg;
                  });
                },
                labelText: "Kata Sandi Sekarang",
                hintText: "Masukkan Kata Sandi Sekarang",
              ),
              const SizedBox(height: 15),
              CustomTextField(
                controller: newPassController,
                obscureText: _obscurePasswordbaru,
                prefixIcon: Icons.lock,
                suffixIcon: _obscurePasswordbaru
                    ? Icons.visibility_off
                    : Icons.visibility,
                onSuffixPressed: () {
                  setState(() {
                    _obscurePasswordbaru = !_obscurePasswordbaru;
                  });
                },
                labelText: "Kata Sandi Baru",
                hintText: "Masukkan Kata Sandi Baru",
              ),
              const SizedBox(height: 15),
              CustomTextField(
                controller: confirmController,
                obscureText: _obscurePasswordkonskrg,
                prefixIcon: Icons.lock,
                suffixIcon: _obscurePasswordkonskrg
                    ? Icons.visibility_off
                    : Icons.visibility,
                onSuffixPressed: () {
                  setState(() {
                    _obscurePasswordkonskrg = !_obscurePasswordkonskrg;
                  });
                },
                labelText: "Konfirmasi Kata Sandi Sekarang",
                hintText: "Masukkan Konfirmasi Kata Sandi Baru",
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: chgPass,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: const Text(
                    "Ubah Password",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
