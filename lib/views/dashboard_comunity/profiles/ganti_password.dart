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

  Future<void> chgPass(BuildContext context) async {
    final userList = await DatabaseHelper().getUser();
    final nik = userList.first.nik;
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
        print(response.data);

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
                "Harap masukkan Kata Sandi baru untuk emperbarui informasi Anda"),
                SizedBox(height: 16,),
                 CustomTextField(
              controller: passwordController,
              obscureText: _obscureOldPass,
              keyboardType: TextInputType.text,
                          prefixIcon: Icons.lock,
                          suffixIcon: _obscureOldPass
                              ? Icons.visibility_off
                              : Icons.visibility,
                          onSuffixPressed: () {
                            setState(() {
                              _obscureOldPass = !_obscureOldPass;
                            });
                          },
                labelText: "Kata Sandi Sekarang",
                hintText: "Kata Sandi Sekarang",

            
            ),
            // TextField(
            //   controller: passwordController,
            //   obscureText: _obscureOldPass,
            //   decoration:  InputDecoration(
            //     labelText: "Kata Sandi Sekarang",
            //     border: OutlineInputBorder(),
            //     suffixIcon: IconButton(
            //       icon: Icon(_obscureOldPass ? Icons.visibility : Icons.visibility_off),
            //       onPressed: () {
            //         setState(() {
            //           _obscureOldPass = !_obscureOldPass;
            //         });
            //       },
            //     ),
            //   ),
            // ),
            const SizedBox(height: 20),
             CustomTextField(
              controller: newPassController,
              obscureText: _obscureNewPass,
              keyboardType: TextInputType.text,
                          prefixIcon: Icons.lock,
                          suffixIcon: _obscureNewPass
                              ? Icons.visibility_off
                              : Icons.visibility,
                          onSuffixPressed: () {
                            setState(() {
                              _obscureNewPass = !_obscureNewPass;
                            });
                          },
                labelText: "Kata Sandi Baru",
                hintText: " Kata Sandi Baru",

            
            ),
          
            const SizedBox(height: 15),
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
                labelText: "Konfirmasi Kata Sandi Baru",
                hintText: "Konfirmasi Kata Sandi Baru",

            
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => chgPass(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: const Text(
                  "Ubah Password",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
