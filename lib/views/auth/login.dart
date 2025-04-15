import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../methods/api.dart';
import '../../theme/theme.dart';
import 'verifikasi.dart';
import '../dashboard_comunity/dashboard/dashboard_warga.dart';
import '../../widgets/costum_scaffold1.dart';
import '../../widgets/costum_texfield.dart';

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

  void loginUser() async {
    final data = {
      'nik': nikController.text.trim(),
      'password': passwordController.text.trim(),
    };

    print("Mengirim request login dengan data: $data");

    try {
      final response = await API().postRequest(route: '/login', data: data);
      final responseData = jsonDecode(response.body);

      print("Response dari API: $responseData"); // Debugging

      if (response.statusCode == 200 && responseData.containsKey('token')) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.setInt('user_id', responseData['user']['id']);
        await preferences.setString(
            'nik', responseData['user']['masyarakat']['nik']);
        await preferences.setString('token', responseData['token']);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'])),
        );

        print("Navigasi ke Dashboard...");
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => DashboardPage()),
        );
      } else {
        print("Login gagal: ${responseData['message']}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login gagal: ${responseData['message']}')),
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
    return CustomScaffold(
      child: Column(
        children: [
          const SizedBox(height: 50),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formSignInKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          color: Color.fromARGB(255, 12, 35, 95),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25.0),
                        child: Image.asset(
                          'assets/images/logg.png',
                          height: 170,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      CustomTextField(
                        labelText: "Nomer Induk Kependudukan",
                        hintText: "Masukkan NIK",
                        controller: nikController,
                        keyboardType: TextInputType.number,
                        prefixIcon: Icons.card_membership,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Masukkan NIK Anda';
                          } else if (value.length < 16) {
                            return 'NIK harus 16 digit';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
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
                      const SizedBox(height: 20.0),
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
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: () {
                          print("Tombol login ditekan!");
                          if (_formSignInKey.currentState!.validate()) {
                            loginUser();
                          }
                        },
                        child: Text("Login"),
                      ),
                      const SizedBox(height: 20.0),
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
    );
  }
}
