import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sibadeanmob_v2_fix/helper/database.dart';
import 'package:sibadeanmob_v2_fix/widgets/costum_texfield.dart';

import '../../../methods/api.dart';

class GantiNoHpPage extends StatefulWidget {
  const GantiNoHpPage({super.key});

  @override
  State<GantiNoHpPage> createState() => _GantiNoHpPageState();
}

class _GantiNoHpPageState extends State<GantiNoHpPage> {
  final noHpController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Tambahkan ini

  @override
  void dispose() {
    noHpController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> chgNoHp() async {
    FocusScope.of(context).unfocus(); // Tutup keyboard
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final userList = await DatabaseHelper().getUser();

    if (userList.isEmpty) {
      _showSnackBar('Data pengguna tidak ditemukan.');
      return;
    }

    final nik = userList.first.nik;
    final noHp = noHpController.text.trim();

    try {
      final response = await API().chgNoHp(nik: nik, noHp: noHp);
      print(response.data);

      if (response.statusCode == 200) {
        _showSnackBar(response.data['message'] ?? 'Nomor HP berhasil diubah');
        Navigator.pop(context);
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(builder: (context) => const DashboardPage()),
        // );
      } else {
        final errorMessage =
            response.data['message'] ?? 'Gagal mengubah nomor HP';
        _showSnackBar('Gagal: $errorMessage');
      }
    } catch (e) {
      _showSnackBar('Terjadi kesalahan: ${e.toString()}');
    }
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
        title: Text("Ganti nomor telepon",
            style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  controller: noHpController,
                  maxLength: 13,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  labelText: "Nomor telepon",
                  hintText: "Nomor telepon",
                  validator: (noHp) {
                    if (noHp == null || noHp.isEmpty) {
                      return ('Nomor HP tidak boleh kosong.');
                    } else if (!RegExp(r'^[0-9]+$').hasMatch(noHp)) {
                      return ('Nomor HP hanya boleh berisi angka.');
                    } else if (noHp.length < 12 || noHp.length > 13) {
                      return ('Nomor HP harus terdiri dari 12 hingga 13 digit.');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: chgNoHp,
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
            )),
      ),
    );
  }
}
