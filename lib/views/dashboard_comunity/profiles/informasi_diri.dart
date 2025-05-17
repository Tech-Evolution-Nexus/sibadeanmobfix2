import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sibadeanmob_v2_fix/helper/database.dart';
import 'package:sibadeanmob_v2_fix/methods/api.dart';
import 'package:sibadeanmob_v2_fix/methods/auth.dart';
import 'package:sibadeanmob_v2_fix/models/MasyarakatModel.dart';
import 'package:sibadeanmob_v2_fix/theme/theme.dart';

class InformasiDiriPage extends StatefulWidget {
  const InformasiDiriPage({super.key});

  @override
  _InformasiDiriPageState createState() => _InformasiDiriPageState();
}

class _InformasiDiriPageState extends State<InformasiDiriPage> {
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  bool isEditingktp = false;
  bool isEditingkk = false;
  String nik = "";
  MasyarakatModel? dataModel;

  File? _ktpFile;
  String? _ktpFileName;

  File? _kkFile;
  String? _kkFileName;
  Future<void> getUserData() async {
    final userList = await Auth.user();
    setState(() {
      nik = userList['nik'] ?? "NIK tidak ditemukan";
    });
    var response = await API().profiledata(nik: nik);
    // print(response);
    if (response.statusCode == 200) {
      setState(() {
        dataModel = MasyarakatModel.fromJson(response.data['data']);
        // isLoading = false;
        // print('DATA MODEL:\n$dataModel');
      });
    }
  }

  void pickFile(String docType) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
      withData: true,
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      String name = result.files.single.name;

      setState(() {
        if (docType == 'ktp') {
          _ktpFile = file;
          _ktpFileName = file.path;
        } else if (docType == 'kk') {
          _kkFile = file;
          _kkFileName = file.path;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File $docType berhasil dipilih')),
      );
    }
  }

  Future<void> _updateDatagambar(String data, File file) async {
    final userList = await Auth.user();

    bool fileExists = await file.exists();
    if (!fileExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File tidak ditemukan')),
      );
      return;
    }

    final fileName = file.path.split('/').last;
    // final prefs = await SharedPreferences.getInstance();

    final nik = userList['nik'];
    final noKK = userList['noKK'];

    final formMap = <String, dynamic>{
      'file': await MultipartFile.fromFile(file.path, filename: fileName),
    };

    if (data == "ktp" && nik != null) {
      formMap['nik'] = nik;
    } else if (data == "kk" && noKK != null) {
      formMap['no_kk'] = noKK;
    }

    final formData = FormData.fromMap(formMap);
    try {
      if (data == "ktp") {
        var response = await API().updategambarktp(formData: formData);
        print(response);
        setState(() {
          isEditingktp = false;
          _ktpFileName = "";
        });
      } else if (data == "kk") {
        var response = await API().updategambarkk(formData: formData);
        ;
        setState(() {
          isEditingkk = false;
          _kkFileName = "";
        });
      }
      await getUserData();
    } catch (e) {
      print("Gagal mengirim data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengirim data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              // Background biru
              Image.asset(
                'assets/images/6.jpg',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),

              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 60),
                child: Column(
                  children: [
                    Gap(100),

                    /// --- Informasi Umum ---
                    Card(
                      color: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.black26, width: 0.2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dataModel?.namaLengkap ?? "Nama tidak tersedia",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 4),
                            Text(
                                "${dataModel?.user?.email ?? 'Email tidak tersedia'} | ${dataModel?.nik ?? 'NIK tidak tersedia'}"),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.work,
                                        size: 18), // Ikon untuk profesi
                                    SizedBox(width: 4),
                                    Text(dataModel?.pekerjaan ??
                                        'Pekerjaan tidak tersedia'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.phone,
                                        size: 18), // Ikon untuk nomor HP
                                    SizedBox(width: 4),
                                    Text("081238382834"),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.phone,
                                        size: 18), // Ikon untuk agama
                                    SizedBox(width: 4),
                                    Text(dataModel?.agama ??
                                        'Agama tidak tersedia'),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(dataModel?.kartuKeluarga?.alamat ??
                                'Alamat tidak tersedia'),
                          ],
                        ),
                      ),
                    ),

                    Gap(10),

                    /// --- Dokumen KK ---
                    UploadDokumenWidget(
                      title: 'Dokumen Kartu Keluarga',
                      isEditing: isEditingkk,
                      onEditToggle: () {
                        setState(() {
                          isEditingkk = !isEditingkk;
                          _kkFileName = "";
                        });
                      },
                      selectedFileName: isEditingkk
                          ? _kkFileName
                          : dataModel?.kartuKeluarga?.kkgambar,
                      onFilePick: () => pickFile('kk'),
                      showSaveButton: isEditingkk,
                      onSave: () async {
                        if (_kkFile != null) {
                          await _updateDatagambar("kk", _kkFile!);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Silakan pilih file terlebih dahulu')),
                          );
                        }
                      },
                    ),

                    Gap(10),

                    /// --- Dokumen KTP ---
                    UploadDokumenWidget(
                      title: 'Dokumen Ktp',
                      isEditing: isEditingktp,
                      onEditToggle: () {
                        setState(() {
                          isEditingktp = !isEditingktp;
                        });
                      },
                      selectedFileName:
                          isEditingktp ? _ktpFileName : dataModel?.ktpgambar,
                      onFilePick: () => pickFile('ktp'),
                      showSaveButton: isEditingktp,
                      onSave: () async {
                        if (_ktpFile != null) {
                          await _updateDatagambar("ktp", _ktpFile!);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Silakan pilih file terlebih dahulu')),
                          );
                        }
                      },
                    ),
                    Gap(10),
                  ],
                ),
              ),

              // Tombol kembali
              Positioned(
                top: 10,
                left: 16,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UploadDokumenWidget extends StatelessWidget {
  final String title;
  final bool isEditing;
  final VoidCallback? onEditToggle;
  final VoidCallback onFilePick;
  final String? selectedFileName;
  final bool showSaveButton;
  final VoidCallback? onSave;

  const UploadDokumenWidget({
    required this.title,
    required this.isEditing,
    required this.onFilePick,
    this.onEditToggle,
    this.selectedFileName,
    this.showSaveButton = false,
    this.onSave,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.black26, width: 0.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header dan tombol edit (opsional)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                if (onEditToggle != null)
                  IconButton(
                    icon: Icon(
                      isEditing ? Icons.close : Icons.edit,
                      color: Colors.grey,
                    ),
                    onPressed: onEditToggle,
                  ),
              ],
            ),
            const SizedBox(height: 8),

            /// Area upload file
            GestureDetector(
              onTap: isEditing || onEditToggle == null ? onFilePick : null,
              child: Opacity(
                opacity: isEditing || onEditToggle == null ? 1.0 : 0.5,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26, width: 0.5),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade100,
                  ),
                  child: selectedFileName != null &&
                          selectedFileName!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: selectedFileName!.startsWith('http')
                              ? Image.network(
                                  selectedFileName!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.network(
                                      'https://dummyimage.com/80x80/f2f2f2/555555&text=No+Image',
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                              : Image.file(
                                  File(
                                      selectedFileName!), // load dari file lokal
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.broken_image);
                                  },
                                ),
                        )
                      : Row(
                          children: const [
                            Icon(Icons.upload_file, color: Colors.grey),
                            SizedBox(width: 8),
                            Text(
                              "Pilih file...",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Format yang didukung:JPG, PNG (Max 2MB)",
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),

            if (showSaveButton && onSave != null) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: onSave,
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text(
                    "Simpan",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: lightColorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
