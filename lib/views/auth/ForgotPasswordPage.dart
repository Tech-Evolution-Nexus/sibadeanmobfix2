import 'package:flutter/material.dart';
import 'package:sibadeanmob_v2_fix/methods/api.dart';
import 'package:sibadeanmob_v2_fix/views/auth/login.dart';
import 'package:sibadeanmob_v2_fix/widgets/costum_texfield.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool isLoading = false;
  String? emailErr = "";
  String status = "idle";
  String alertMessage =
      "Silakan masukkan email Anda untuk menerima link reset password.";
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  void _sendResetLink() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      String email = _emailController.text;
      var response = await API().forgotPassword(email: email);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Link reset password telah dikirim!')),
        );

        setState(() {
          alertMessage =
              "Link reset password telah dikirim ke email $email. Silakan cek email Anda.";
          emailErr = "";
          status = "send";
        });
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          emailErr = response.data['message'];
        });
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      setState(() {
        alertMessage =
            "Maaf, terjadi gangguan pada server. Silakan coba kembali dalam beberapa saat.";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan. Coba lagi!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(
              Icons.chevron_left,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text("Lupa Password",
              style: TextStyle(color: Colors.black, fontSize: 18)),
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                status == "idle"
                                    ? Image.asset(
                                        'assets/images/lupa-password.png',
                                        height: deviceWidth * 0.6,
                                        fit: BoxFit.contain,
                                      )
                                    : Image.asset(
                                        'assets/images/reset-password.png',
                                        height: deviceWidth * 0.6,
                                        fit: BoxFit.contain,
                                      ),
                                const SizedBox(height: 30),
                                if (alertMessage != "") ...[
                                  const Text(
                                    "Lupa password",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Text(
                                      alertMessage,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        // fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                ],
                                Visibility(
                                  visible: status != "idle",
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            status = "idle";
                                            emailErr = "";
                                            alertMessage =
                                                "Silakan masukkan email Anda untuk menerima link reset password.";
                                            _emailController
                                                .clear(); // Kosongkan jika mau
                                          });
                                        },
                                        child: const Text("Gunakan email lain"),
                                      ),
                                      const SizedBox(width: 20),
                                      TextButton(
                                        onPressed: _sendResetLink,
                                        child: const Text("Kirim ulang?"),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                    visible: status == "idle",
                                    child: CustomTextField(
                                      errorText:
                                          emailErr == "" ? null : emailErr,
                                      hintText: "Email",
                                      labelText: "Email",
                                      controller: _emailController,
                                      validator: (val) {
                                        if (val == null || val.isEmpty) {
                                          return "Email wajib diisi";
                                        }
                                        return null;
                                      },
                                    )),
                              ],
                            ),
                            const SizedBox(height: 40),
                            Visibility(
                                visible: status == "idle",
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: _sendResetLink,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isLoading
                                          ? Colors.grey.shade300
                                          : Theme.of(context)
                                              .colorScheme
                                              .primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'Kirim',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ));
  }
}
