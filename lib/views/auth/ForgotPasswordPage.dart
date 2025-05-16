import 'package:flutter/material.dart';
import 'package:sibadeanmob_v2_fix/methods/api.dart';
import 'package:sibadeanmob_v2_fix/views/auth/forgotpasswort.dart';
import 'package:sibadeanmob_v2_fix/views/auth/login.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  void _sendResetLink() async {
    try {
      var response = await API().forgotPassword(email: _emailController.text);
      print(response);
      if (response.statusCode == 200) {
        // Success, handle response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Link reset password telah dikirim!')),
        );
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => Login()));
      }
    } catch (e) {
      // Error handling
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan. Coba lagi!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forgot Password')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendResetLink,
              child: Text('Kirim Link Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
