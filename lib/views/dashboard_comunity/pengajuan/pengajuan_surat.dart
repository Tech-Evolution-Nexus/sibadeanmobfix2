import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../../services/pengajuan_servis.dart';
import '../../../theme/theme.dart';

class PengajuanSuratPage extends StatefulWidget {
  final String jenisSurat;
  final String namaSurat;

  const PengajuanSuratPage({
    Key? key,
    required this.jenisSurat,
    required this.namaSurat,
  }) : super(key: key);

  @override
  _PengajuanSuratPageState createState() => _PengajuanSuratPageState();
}

class _PengajuanSuratPageState extends State<PengajuanSuratPage> {
  final _formKey = GlobalKey<FormState>();
  File? _selectedFile;
  Uint8List? _selectedFileBytes;
  String? _fileName;

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf'],
      withData: true,
    );

    if (result != null) {
      setState(() {
        _fileName = result.files.single.name;
        _selectedFileBytes = result.files.single.bytes;
        _selectedFile = result.files.single.path != null
            ? File(result.files.single.path!)
            : null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("File tidak valid atau gagal dipilih")),
      );
    }
  }

  void _submitPengajuan() async {
    if (_formKey.currentState!.validate() && (_selectedFile != null || _selectedFileBytes != null)) {
      var response = await PengajuanService().ajukanSurat(
        nama: _namaController.text,
        nik: _nikController.text,
        alamat: _alamatController.text,
        keterangan: _keteranganController.text,
        fileKK: _selectedFile!,
        jenisSurat: widget.jenisSurat,
      );

      if (response.containsKey("error")) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal mengajukan: ${response['error']}")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Pengajuan berhasil!")),
        );
        Navigator.pop(context);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Mohon lengkapi semua data dan upload KK")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pengajuan ${widget.namaSurat}",
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        backgroundColor: lightColorScheme.primary,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Isi Data Pengajuan:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                TextFormField(
                  controller: _namaController,
                  decoration: InputDecoration(labelText: "Nama Lengkap", border: OutlineInputBorder()),
                  validator: (value) => value!.isEmpty ? "Nama tidak boleh kosong" : null,
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _nikController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "NIK", border: OutlineInputBorder()),
                  validator: (value) => value!.isEmpty ? "NIK harus diisi" : null,
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _alamatController,
                  decoration: InputDecoration(labelText: "Alamat", border: OutlineInputBorder()),
                  validator: (value) => value!.isEmpty ? "Alamat harus diisi" : null,
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _keteranganController,
                  decoration: InputDecoration(labelText: "Keterangan Tambahan", border: OutlineInputBorder()),
                  maxLines: 3,
                ),
                SizedBox(height: 20),
                Text("Upload Kartu Keluarga:", style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                if (_selectedFileBytes != null || _selectedFile != null)
                  Column(
                    children: [
                      Text("File Terpilih: $_fileName",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      if (_fileName != null && (_fileName!.endsWith('.jpg') || _fileName!.endsWith('.png')))
                        _selectedFileBytes != null
                            ? Image.memory(_selectedFileBytes!, height: 100)
                            : _selectedFile != null
                                ? Image.file(_selectedFile!, height: 100)
                                : Container(),
                    ],
                  )
                else
                  Text("Belum ada file yang dipilih", style: TextStyle(color: Colors.grey)),
                SizedBox(height: 10),
                ElevatedButton(onPressed: _pickFile, child: Text("Pilih File KK")),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitPengajuan,
                  child: Text("Ajukan Surat"),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
