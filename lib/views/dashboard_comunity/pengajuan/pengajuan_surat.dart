import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../../services/pengajuan_servis.dart';
import '../../../theme/theme.dart';
import '../../../widgets/costum_texfield.dart';

class PengajuanSuratPage extends StatefulWidget {
  final String namaSurat;

  const PengajuanSuratPage({
    Key? key,
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
  final PageController _pageController = PageController();
  int _currentPage = 0;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController nikController = TextEditingController();
  TextEditingController noKkController = TextEditingController();
  TextEditingController tempatLahirController = TextEditingController();
  TextEditingController tanggalLahirController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController pekerjaanController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController rtController = TextEditingController();
  TextEditingController rwController = TextEditingController();

  String? selectedGender;
  String? selectedAgama;

  // Image File
  File? kkGambar;
  Uint8List? kkGambarBytes;
  void nextPage() {
    if (_formKey.currentState!.validate()) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentPage++);
    }
  }

  void prevPage() {
    _pageController.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() => _currentPage--);
  }

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
    if (_formKey.currentState!.validate() &&
        (_selectedFile != null || _selectedFileBytes != null)) {
      // var response = await PengajuanService().ajukanSurat(
      //   nama: _namaController.text,
      //   nik: _nikController.text,
      //   alamat: _alamatController.text,
      //   keterangan: _keteranganController.text,
      //   fileKK: _selectedFile!,
      //   jenisSurat: "s",
      // );

      // if (response.containsKey("error")) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text("Gagal mengajukan: ${response['error']}")),
      //   );
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text("Pengajuan berhasil!")),
      //   );
      //   Navigator.pop(context);
      // }
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Isi Data Pengajuan:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context)
                          .size
                          .height, // atau MediaQuery.of(context).size.height * 0.8
                      child: PageView(
                        controller: _pageController,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          Column(
                            children: [
                              // CARD 1: BIODATA
                              Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                margin: EdgeInsets.all(16),
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Biodata Warga",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      _buildBiodataItem(
                                          "NIK", "3276011234567890"),
                                      _buildBiodataItem("Nama", "Budi Santoso"),
                                      _buildBiodataItem(
                                          "Jenis Kelamin", "Laki-laki"),
                                      _buildBiodataItem("Tempat, Tgl Lahir",
                                          "Bandung, 01 Jan 1990"),
                                      _buildBiodataItem("Alamat",
                                          "Jl. Merdeka No. 123, Bandung"),
                                      _buildBiodataItem(
                                          "No HP", "081234567890"),
                                      _buildBiodataItem(
                                          "Email", "budi@example.com"),
                                    ],
                                  ),
                                ),
                              ),

                              // CARD 2: UPLOAD FILE DAN TOMBOL
                              Container(
                                width:
                                    double.infinity, // Mengatur lebar Container
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Upload File Pengantar Rt (Opsional):",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        if (_selectedFileBytes != null ||
                                            _selectedFile != null)
                                          Column(
                                            children: [
                                              Text("File Terpilih: $_fileName",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(height: 10),
                                              if (_fileName != null &&
                                                  (_fileName!
                                                          .endsWith('.jpg') ||
                                                      _fileName!
                                                          .endsWith('.png')))
                                                _selectedFileBytes != null
                                                    ? Image.memory(
                                                        _selectedFileBytes!,
                                                        height: 100,
                                                      )
                                                    : _selectedFile != null
                                                        ? Image.file(
                                                            _selectedFile!,
                                                            height: 100,
                                                          )
                                                        : Container(),
                                            ],
                                          )
                                        else
                                          Text("Belum ada file yang dipilih",
                                              style: TextStyle(
                                                  color: Colors.grey)),
                                        SizedBox(height: 10),
                                        ElevatedButton.icon(
                                          onPressed: _pickFile,
                                          icon: Icon(Icons.upload_file),
                                          label: Text("Upload Foto KK"),
                                        ),
                                        if (kkGambar != null ||
                                            kkGambarBytes != null)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0),
                                            child: Text(
                                              "Gambar KK telah dipilih!",
                                              style: TextStyle(
                                                  color: Colors.green),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: ElevatedButton(
                                  onPressed: nextPage,
                                  child: Text("Selanjutnya"),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              CustomTextField(
                                controller: noKkController,
                                labelText: "No KK",
                                hintText: "Masukkan No KK",
                                keyboardType: TextInputType.number,
                                validator: (value) => value!.length != 16
                                    ? "No KK harus 16 digit"
                                    : null,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: prevPage,
                                    child: Text("Kembali"),
                                  ),
                                  ElevatedButton(
                                    onPressed: nextPage,
                                    child: Text("Selanjutnya"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(children: [
                            Container(
                              width: double.infinity,
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Upload File Pengantar Rt (Opsional):",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      if (_selectedFileBytes != null ||
                                          _selectedFile != null)
                                        Column(
                                          children: [
                                            Text("File Terpilih: $_fileName",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            SizedBox(height: 10),
                                            if (_fileName != null &&
                                                (_fileName!.endsWith('.jpg') ||
                                                    _fileName!
                                                        .endsWith('.png')))
                                              _selectedFileBytes != null
                                                  ? Image.memory(
                                                      _selectedFileBytes!,
                                                      height: 100,
                                                    )
                                                  : _selectedFile != null
                                                      ? Image.file(
                                                          _selectedFile!,
                                                          height: 100,
                                                        )
                                                      : Container(),
                                          ],
                                        )
                                      else
                                        Text("Belum ada file yang dipilih",
                                            style:
                                                TextStyle(color: Colors.grey)),
                                      SizedBox(height: 10),
                                      ElevatedButton.icon(
                                        onPressed: _pickFile,
                                        icon: Icon(Icons.upload_file),
                                        label: Text("Upload Foto KK"),
                                      ),
                                      if (kkGambar != null ||
                                          kkGambarBytes != null)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
                                          child: Text(
                                            "Gambar KK telah dipilih!",
                                            style:
                                                TextStyle(color: Colors.green),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: prevPage,
                                  child: Text("Kembali"),
                                ),
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
                          ])
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBiodataItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130, // lebar tetap untuk label agar sejajar
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
