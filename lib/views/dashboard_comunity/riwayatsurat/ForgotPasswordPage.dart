import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final Dio _dio = Dio(); // Dio instance

  void _sendResetLink() async {
    try {
      Response response = await _dio.post(
        'https://your-api-url.com/api/forgot-password',
        data: {'email': _emailController.text},
      );
      if (response.statusCode == 200) {
        // Success, handle response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Link reset password telah dikirim!')),
        );
      }
    } catch (e) {
      // Error handling
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
