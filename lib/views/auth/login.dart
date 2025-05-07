import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/dashboard/dashboard_rt.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/dashboard/dashboard_rw.dart';
import '../../methods/api.dart';
import '../../theme/theme.dart';
import 'verifikasi.dart';
import '../dashboard_comunity/dashboard/dashboard_warga.dart';
import '../../widgets/costum_texfield.dart';
import 'package:sibadeanmob_v2_fix/methods/auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formSignInKey = GlobalKey<FormState>();
  bool rememberPassword = true;
  bool _obscurePassword = true;

  final TextEditingController nikController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    nikController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Delay 3 detik sebelum berpindah ke Login
    // () async {
    //   final user = await Auth.user();
    //   if (user["user_id"] != null) {
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (context) => DashboardPage()),
    //     );
    //   }
    // }();
  }

  void loginUser() async {
    final nik = nikController.text.trim();
    final pass = passwordController.text.trim();
    if (nik.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('NIK dan Password tidak boleh kosong')),
      );
      return;
    }
    try {
      final response = await API().loginUser(nik: nik, password: pass);
      print(response.data);

      if (response.statusCode == 200 &&
          response.data["data"].containsKey('access_token')) {
        final responData = response.data["data"];
        final userData = responData['user'];

        // Periksa role dan simpan data ke SharedPreferences hanya jika role valid
        if (userData['role'] == 'rt' ||
            userData['role'] == 'rw' ||
            userData['role'] == 'masyarakat') {
          // Simpan data ke SharedPreferences
          SharedPreferences preferences = await SharedPreferences.getInstance();
          await preferences.setInt('user_id', userData['id']);
          await preferences.setString('role', userData['role']);
          await preferences.setString(
              'nama', userData['masyarakat']['nama_lengkap']);
          await preferences.setString('nik', userData['masyarakat']['nik']);
          await preferences.setString('noKK', userData['masyarakat']['no_kk']);
          await preferences.setString('token', responData['access_token']);
          // Tampilkan pesan berhasil
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(response.data['message'] ?? 'Login berhasil')),
          );

          // Navigasi ke halaman Dashboard berdasarkan role
          if (userData['role'] == 'rt') {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => DashboardRT()),
            );
          } else if (userData['role'] == 'rw') {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => DashboardRW()),
            );
          } else if (userData['role'] == 'masyarakat') {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => DashboardPage()),
            );
          }
        } else {
          // Jika role tidak valid, tampilkan pesan dan tidak simpan data ke SharedPreferences
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Akses ditolak')),
          );

          // Kembalikan ke halaman login
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Login()),
          );
        }
      } else {
        final errorMessage = response.data['message'] ?? 'Login gagal';
        print("Login gagal: $errorMessage");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login gagal: $errorMessage')),
        );
      }
    } catch (e) {
      print("Terjadi kesalahan: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 20.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0),
                    ),
                  ),
                  child: Form(
                    key: _formSignInKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 0),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30.0),
                          child: Image.asset(
                            'assets/images/weell6.png',
                            height: deviceWidth * 0.5,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 4),
                        CustomTextField(
                          labelText: "Nomer Induk Kependudukan",
                          hintText: "Masukkan NIK",
                          controller: nikController,
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.card_membership,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukkan NIK Anda';
                            } else if (value.length != 16) {
                              return 'NIK harus 16 digit';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 4),
                        CustomTextField(
                          labelText: "Password",
                          hintText: "Masukkan Password",
                          controller: passwordController,
                          keyboardType: TextInputType.text,
                          obscureText: _obscurePassword,
                          prefixIcon: Icons.lock,
                          suffixIcon: _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          onSuffixPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          validator: (value) =>
                              value!.isEmpty ? 'Masukkan Password Anda' : null,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: rememberPassword,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      rememberPassword = value!;
                                    });
                                  },
                                  activeColor: Color.fromARGB(255, 12, 35, 95),
                                ),
                                const Text('Ingat Saya',
                                    style: TextStyle(color: Colors.black45)),
                              ],
                            ),
                            GestureDetector(
                              child: Text(
                                'Lupa Password?',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: lightColorScheme.primary),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double
                              .infinity, // Tombol akan selebar container induknya
                          height: 50, // Tinggi tombol 50
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFF052158), // warna biru gelap
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    12), // sudut tombol agak bulat
                              ),
                            ),
                            onPressed: () {
                              if (_formSignInKey.currentState!.validate()) {
                                loginUser();
                              }
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Belum punya akun? ',
                                style: TextStyle(color: Colors.black45)),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (e) => const Verifikasi()));
                              },
                              child: Text(
                                'Daftar Sekarang',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: lightColorScheme.primary),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
