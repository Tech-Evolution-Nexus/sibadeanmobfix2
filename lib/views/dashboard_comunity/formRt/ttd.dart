import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../../methods/api.dart';
import '../../dashboard_comunity/dashboard/dashboard_warga.dart';
import 'package:sibadeanmob_v2_fix/helper/database.dart';
import 'package:dio/dio.dart';

class TtdPage extends StatefulWidget {
  const TtdPage({super.key});

  @override
  State<TtdPage> createState() => _TtdPageState();
}

final emailController = TextEditingController();

void _showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}

class _TtdPageState extends State<TtdPage> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Tambahkan ini
  File? ttdFile; // Tambahkan ini untuk menyimpan file tanda tangan gambar;
  File? _selectedFile;
  String? _fileName;

  Future<void> ttdclick(BuildContext context) async {
    final userList = await DatabaseHelper().getUser();
    final nik = userList.first.nik;

    try {
      // Buat FormData untuk upload file
      FormData formData = FormData.fromMap({
        'nik': nik,
        'file': await MultipartFile.fromFile(_selectedFile!.path,
            filename: 'ttd.png'),
      });

      final response = await API().ttd(formData);

      print(response.data);

      if (response.statusCode == 200 && response.data['status'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                response.data['message'] ?? 'Tanda tangan berhasil diperbarui'),
          ),
        );
        Navigator.pop(context);
      } else {
        final errorMessage =
            response.data['message'] ?? 'Gagal memperbarui tanda tangan';
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

  Future<void> _pickPengantarFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
      withData: true,
    );
    if (result != null) {
      File file = File(result.files.single.path!);
      String name = result.files.single.name;

      setState(() {
        _selectedFile = file;
        _fileName = name;
      });

      // Show snack bar to confirm the upload
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File untuk tanda tangan telah dipilih')),
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
        title: Text("Tanda Tangan",
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
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Upload  Tanda Tangan",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: _pickPengantarFile,
                          child: Container(
                            width: double.infinity,
                            height: 250,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.shade400,
                                style: BorderStyle.solid,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey.shade50,
                              image: _selectedFile != null &&
                                      (_fileName
                                                  ?.toLowerCase()
                                                  .endsWith('.jpg') ==
                                              true ||
                                          _fileName
                                                  ?.toLowerCase()
                                                  .endsWith('.jpeg') ==
                                              true ||
                                          _fileName
                                                  ?.toLowerCase()
                                                  .endsWith('.png') ==
                                              true)
                                  ? DecorationImage(
                                      image: FileImage(_selectedFile!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: _selectedFile == null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.cloud_upload_outlined,
                                        size: 40,
                                        color: Colors.blueAccent,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        _fileName ?? "Klik untuk memilih file",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      _fileName ?? '',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        backgroundColor: Colors.black38,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        /// Pesan berhasil
                        if (ttdFile != null)
                          Row(
                            children: const [
                              Icon(Icons.check_circle, color: Colors.green),
                              SizedBox(width: 8),
                              Text(
                                "File berhasil dipilih!",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Validasi dulu
                    if (_formKey.currentState!.validate()) {
                      ttdclick(context);
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
                    style: TextStyle(color: Colors.white),
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
