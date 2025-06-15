import 'package:flutter/material.dart';
import 'package:sibadeanmob_v2_fix/widgets/costum_texfield.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import '../../../methods/api.dart';
import '../../dashboard_comunity/dashboard/dashboard_warga.dart';
import 'package:sibadeanmob_v2_fix/helper/database.dart';

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

  //state utk show/hide password
  bool _obscureOldPass = true;
  bool _obscureNewPass = true;
  bool _obscureConfirmPass = true;
  final _formKey = GlobalKey<FormState>(); // Tambahkan ini

  Future<void> chgPass(BuildContext context) async {
    final userList = await DatabaseHelper().getUser();
    final nik = userList.first.nik;
    final currentPass = passwordController.text.trim();
    final newPass = newPassController.text.trim();
    final confPass = confirmController.text.trim();

    try {
      final response = await API().chgPass(
        nik: nik,
        password: currentPass,
        newPass: newPass,
        confPass: confPass,
      );

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

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Gagal'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print("Error: $e");

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Kesalahan'),
          content: Text('Terjadi kesalahan: ${e.toString()}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tutup'),
            ),
          ],
        ),
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Ganti kata sandi",
            style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  "Silakan masukkan kata sandi baru untuk memperbarui akun Anda."),
              SizedBox(
                height: 16,
              ),
              CustomTextField(
                controller: passwordController,
                obscureText: _obscureOldPass,
                keyboardType: TextInputType.text,
                prefixIcon: Icons.lock,
                suffixIcon:
                    _obscureOldPass ? Icons.visibility_off : Icons.visibility,
                onSuffixPressed: () {
                  setState(() {
                    _obscureOldPass = !_obscureOldPass;
                  });
                },
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Kata sandi  wajib diisi";
                  }
                  return null;
                },
                labelText: "Kata sandi sekarang",
                hintText: "Kata sandi sekarang",
              ),
              const SizedBox(height: 0),
              CustomTextField(
                controller: newPassController,
                obscureText: _obscureNewPass,
                keyboardType: TextInputType.text,
                prefixIcon: Icons.lock,
                suffixIcon:
                    _obscureNewPass ? Icons.visibility_off : Icons.visibility,
                onSuffixPressed: () {
                  setState(() {
                    _obscureNewPass = !_obscureNewPass;
                  });
                },
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Kata sandi baru wajib diisi";
                  } else if (val.length < 6) {
                    return " Kata sandi tidak minimal 6 karakter";
                  }
                  return null;
                },
                labelText: "Kata sandi baru",
                hintText: " Kata sandi baru",
              ),
              const SizedBox(height: 0),
              CustomTextField(
                controller: confirmController,
                obscureText: _obscureConfirmPass,
                keyboardType: TextInputType.text,
                prefixIcon: Icons.lock,
                suffixIcon: _obscureConfirmPass
                    ? Icons.visibility_off
                    : Icons.visibility,
                onSuffixPressed: () {
                  setState(() {
                    _obscureConfirmPass = !_obscureConfirmPass;
                  });
                },
                validator: (val) {
                  final newPass = newPassController.text.trim();
                  final confPass = confirmController.text.trim();
                  if (val == null || val.isEmpty) {
                    return "Konfirmasi Kata sandi baru wajib diisi";
                  } else if (val.length < 6) {
                    return "Konfirmasi Kata sandi minimal 6 karakter";
                  } else if (newPass != confPass) {
                    return "Konfirmasi Kata sandi tidak sama";
                  }
                  return null;
                },
                labelText: "Konfirmasi kata sandi baru",
                hintText: "Konfirmasi kata sandi baru",
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      chgPass(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            12), // sudut tombol agak bulat
                      )),
                  child: const Text(
                    "Simpan",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
