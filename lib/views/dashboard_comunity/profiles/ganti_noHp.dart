import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import '../../../methods/api.dart';
import '../../dashboard_comunity/dashboard/dashboard_warga.dart';
import 'package:sibadeanmob_v2_fix/helper/database.dart';

class GantiNoHpPage extends StatefulWidget {
  const GantiNoHpPage({super.key});

  @override
  State<GantiNoHpPage> createState() => _GantiNoHpPageState();
}

class _GantiNoHpPageState extends State<GantiNoHpPage> {
  final noHpController = TextEditingController();

  @override
  void dispose() {
    noHpController.dispose();
    super.dispose();
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> chgNoHp(BuildContext context) async {
    final userList = await DatabaseHelper().getUser();
    final nik = userList.first.nik;
    final noHp = noHpController.text.trim();

    if (nik.isEmpty || noHp.isEmpty) {
      _showSnackBar(context, 'NIK dan Nomor HP tidak boleh kosong.');
      return;
    } else if (!RegExp(r'^[0-9]+$').hasMatch(noHp)) {
      _showSnackBar(context, 'Nomor HP hanya boleh berisi angka.');
      return;
    } else if (noHp.length < 12 || noHp.length > 13) {
      _showSnackBar(context, 'Nomor HP harus terdiri dari 12 hingga 13 digit.');
      return;
    }

    try {
      final response = await API().chgNoHp(nik: nik, noHp: noHp);
      print(response.data);

      if (response.statusCode == 200) {
        _showSnackBar(
            context, response.data['message'] ?? 'Nomor HP berhasil diubah');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => DashboardPage()),
        );
      } else {
        final errorMessage =
            response.data['message'] ?? 'Gagal mengubah nomor HP';
        _showSnackBar(context, 'Gagal: $errorMessage');
      }
    } catch (e) {
      _showSnackBar(context, 'Terjadi kesalahan: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ganti Nomor HP")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Masukkan nomor HP baru Anda"),
            const SizedBox(height: 20),
            TextField(
              controller: noHpController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: "Nomor HP",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => chgNoHp(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: const Text(
                  "Ubah Nomor HP",
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
