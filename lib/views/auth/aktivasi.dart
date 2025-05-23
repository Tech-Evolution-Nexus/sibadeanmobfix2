import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:sibadeanmob_v2_fix/widgets/costum_button.dart';
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
  final _formKey = GlobalKey<FormState>();
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
    if (_formKey.currentState!.validate()) {
      final email = emailController.text.trim();
      final phone = phoneController.text.trim();
      final password = passwordController.text;

      // Validasi manual (jika belum pakai Form + validator)
      if (email.isEmpty || phone.isEmpty || password.isEmpty) {
        _showSnackBar("Harap lengkapi semua field!", isError: true);
        return;
      }

      setState(() => _isLoading = true);

      try {
        final response = await API().aktivasiAkun(
          nik: widget.nik,
          email: email,
          nohp: phone,
          pass: password,
        );

        if (response == null) {
          _showSnackBar("Tidak ada respon dari server.", isError: true);
          return;
        }

        if (response.statusCode == 200) {
          _showAlertDialog(
            "Aktivasi Berhasil",
            "Akun Anda berhasil diaktivasi. Silakan login.",
            onConfirm: () {
              context.go("/login");
            },
          );
        } else {
          _showSnackBar(
            "Aktivasi gagal. Kode: ${response.statusCode}",
            isError: true,
          );
        }
      } catch (e) {
        _showSnackBar("Gagal menghubungi server. Cek koneksi Anda.",
            isError: true);
      } finally {
        setState(() => _isLoading = false);
      }
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
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Lengkapi input berikut untuk mengaktivkan akun anda",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(179, 5, 5, 5),
                  ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 30.0),
                CustomTextField(
                  labelText: "Email",
                  hintText: "Masukkan Email Aktif",
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    } else if (!value.contains('@')) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  labelText: "No HP",
                  hintText: "Masukkan Nomor HP",
                  maxLength: 13,
                  controller: phoneController,
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nomor HP tidak boleh kosong';
                    } else if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value)) {
                      return 'Nomor HP tidak valid';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  labelText: "Password",
                  hintText: "Masukkan Password",
                  controller: passwordController,
                  prefixIcon: Icons.lock,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    } else if (value.length < 6) {
                      return 'Password minimal 6 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: _isLoading ? 'Mengaktifasi...' : 'Aktifasi',
                  onPressed: _isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            aktivasiAkun();
                          }
                        },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
