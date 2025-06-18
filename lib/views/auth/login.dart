import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:sibadeanmob_v2_fix/helper/database.dart';
import 'package:sibadeanmob_v2_fix/models/AuthUserModel.dart';
import 'package:sibadeanmob_v2_fix/views/auth/ForgotPasswordPage.dart';
import '../../methods/api.dart';
import 'verifikasi.dart';
import '../../widgets/costum_texfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formSignInKey = GlobalKey<FormState>();
  bool rememberPassword = true;
  bool _obscurePassword = true;
  bool isLoading = false;

  final TextEditingController nikController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    nikController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _markWelcome();
  }

  void _markWelcome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('seenOnboarding', true);

    print("bool " + prefs.getBool('seenOnboarding').toString());
  }

  void loginUser() async {
    setState(() {
      isLoading = true;
    });
    final nik = nikController.text.trim();
    final pass = passwordController.text.trim();

    if (nik.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('NIK dan Password tidak boleh kosong')),
      );
      return;
    }
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        final response =
            await API().loginUser(nik: nik, password: pass, token: fcmToken);
        final data = response!.data['data'];
        final userData = data?['user'];
        final masyarakat = userData?['masyarakat'];

        if (response!.statusCode == 200 && data?['access_token'] != null) {
          if (userData == null || masyarakat == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Data user tidak lengkap')),
            );
            return;
          }

          final user = AuthUserModel(
            id: userData['id'],
            role: userData['role'],
            email: userData['email'],
            nama_lengkap: masyarakat['nama_lengkap'],
            nik: masyarakat['nik'],
            no_kk: masyarakat['no_kk'],
            access_token: data['access_token'],
            // fcm_token: data['fcm_token'],
          );
          setState(() {
            isLoading = false;
          });
          await DatabaseHelper().insertUser(user);
          // await FirebaseMessaging.instance.subscribeToTopic('all_users');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(response!.data['message'] ?? 'Login berhasil')),
          );

          // Navigasi sesuai role
          switch (user.role) {
            case 'rt':
              context.go("/dashboard_rt");
              break;
            case 'rw':
              context.go("/dashboard_rw");
              break;
            default:
              context.go("/dashboard_warga");
              break;
          }
        } else {
          final errorMessage = response.data['message'] ?? 'Login gagal';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login gagal: $errorMessage')),
          );
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: ${e.toString()}')),
      );
      setState(() {
        isLoading = false;
      });
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
                controller: _scrollController,
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
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Mengarahkan ke halaman ForgotPasswordPage
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ForgotPasswordPage()),
                                );
                              },
                              child: Text(
                                'Lupa Password?',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary, // Sesuaikan dengan warna Anda
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double
                              .infinity, // Tombol akan selebar container induknya
                          height: 50, // Tinggi tombol 50
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isLoading
                                  ? Colors.grey.shade300
                                  : Theme.of(context)
                                      .colorScheme
                                      .primary, // warna biru gelap
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    12), // sudut tombol agak bulat
                              ),
                            ),
                            onPressed: isLoading
                                ? null
                                : () {
                                    if (_formSignInKey.currentState!
                                        .validate()) {
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
                                    color:
                                        Theme.of(context).colorScheme.primary),
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
