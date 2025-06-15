import 'package:flutter/material.dart';
import 'package:sibadeanmob_v2_fix/widgets/costum_texfield.dart';
import '../../../methods/api.dart';
import '../../dashboard_comunity/dashboard/dashboard_warga.dart';
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
  final _formKey = GlobalKey<FormState>(); // Tambahkan ini

  Future<void> chgEmail(BuildContext context) async {
    final userList = await DatabaseHelper().getUser();
    final nik = userList.first.nik;
    final email = emailController.text.trim();

    try {
      final response = await API().chgEmail(nik: nik, email: email);
      print(response.data);

      if (response.statusCode == 200) {
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: $errorMessage')),
        );
      }
    } catch (e) {
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Ganti email",
            style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          // Bungkus di dalam Form
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const Text(
              //     "Harap masukkan alamat email baru untuk\nmemperbarui informasi Anda"),
              // const SizedBox(height: 10),
              CustomTextField(
                controller: emailController,
                // decoration: const InputDecoration(
                //   labelText: "Email",
                //   border: OutlineInputBorder(),
                // ),
                labelText: "Email",
                hintText: "Email",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Format email tidak valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Validasi dulu
                    if (_formKey.currentState!.validate()) {
                      chgEmail(context);
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
                    style: TextStyle(color: Colors.white, fontSize: 16),
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
