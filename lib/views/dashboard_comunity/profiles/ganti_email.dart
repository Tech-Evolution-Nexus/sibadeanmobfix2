import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../methods/api.dart';
import '../../dashboard_comunity/dashboard/dashboard_warga.dart';
import '../../../models/userModel.dart';
import 'package:sibadeanmob_v2_fix/helper/database.dart';

class GantiEmailPage extends StatefulWidget {
  const GantiEmailPage({super.key});

  @override
  State<GantiEmailPage> createState() => _GantiEmailPageState();
}

final emailController = TextEditingController();

void _showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}

class _GantiEmailPageState extends State<GantiEmailPage> {
  final emailController = TextEditingController();

  Future<void> chgEmail(BuildContext context) async {
    final userList = await DatabaseHelper().getUser();
    final nik = userList.first.nik;
    final email = emailController.text.trim();

    try {
      final response = await API().chgEmail(nik: nik, email: email);
      print(response.data);

      if (response.statusCode == 200) {
        // UserModel updatedUser = UserModel.fromJson(response.data);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(response.data['message'] ?? 'Email berhasil diubah')),
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => DashboardPage()),
        );
      } else {
        final errorMessage = response.data['message'] ?? 'Gagal mengubah email';
        print("Gagal: $errorMessage");
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
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ganti Email")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                "Harap masukkan alamat email baru untuk\nmemperbarui informasi Anda"),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  chgEmail(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary),
                child: const Text(
                  "Ubah Email",
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
