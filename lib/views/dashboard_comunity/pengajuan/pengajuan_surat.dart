import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sibadeanmob_v2_fix/methods/api.dart';
import 'package:sibadeanmob_v2_fix/models/LampiranSuratModel.dart';
import 'package:sibadeanmob_v2_fix/models/MasyarakatModel.dart';
import 'package:sibadeanmob_v2_fix/models/suratlampiranmodel.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/profiles/informasi_diri.dart';
import '../../../services/pengajuan_servis.dart';
import '../../../theme/theme.dart';
import '../../../widgets/costum_texfield.dart';
import 'package:dio/dio.dart';

class PengajuanSuratPage extends StatefulWidget {
  final String namaSurat;
  final int idsurat;
  final String nik;

  const PengajuanSuratPage({
    super.key,
    required this.namaSurat,
    required this.idsurat,
    required this.nik,
  });

  @override
  _PengajuanSuratPageState createState() => _PengajuanSuratPageState();
}

class _PengajuanSuratPageState extends State<PengajuanSuratPage> {
  final _formKey = GlobalKey<FormState>();

  SuratLampiranModel? dataModel;
  MasyarakatModel? dataModelUser;

  bool isLoading = true;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  // TextEditingController fullNameController = TextEditingController();
  // TextEditingController nikController = TextEditingController();
  // TextEditingController noKkController = TextEditingController();
  // TextEditingController tempatLahirController = TextEditingController();
  // TextEditingController tanggalLahirController = TextEditingController();
  // TextEditingController alamatController = TextEditingController();
  // TextEditingController pekerjaanController = TextEditingController();
  // TextEditingController phoneController = TextEditingController();
  // TextEditingController emailController = TextEditingController();
  // TextEditingController passwordController = TextEditingController();
  // TextEditingController confirmPasswordController = TextEditingController();
  // TextEditingController rtController = TextEditingController();
  // TextEditingController rwController = TextEditingController();
  List<TextEditingController> fieldControllers = [];
  String? selectedGender;
  String? selectedAgama;
  Map<String, File> lampiranFiles = {};
  // Image File
  File? _selectedFile;
  // Uint8List? _selectedFileBytes;
  String? _fileName;
  // Uint8List? PengantarRtgambarBytes;
  File? PengantarRtgambar;
  // String? kkFileName;
  @override
  void initState() {
    super.initState();
    fetchUser();
    fetchSurat();
  }

  void nextPage() {
    final isKtpKosong =
        dataModelUser?.ktpgambar == null || dataModelUser?.ktpgambar == "";
    final isKkKosong = dataModelUser?.kartuKeluarga?.kkgambar == null ||
        dataModelUser?.kartuKeluarga?.kkgambar == "";

    // Validasi file KK dan KTP wajib ada
    if (isKtpKosong || isKkKosong) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Perhatian"),
          content: Text(
              "Harap unggah file KTP dan KK terlebih dahulu sebelum melanjutkan."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InformasiDiriPage(),
                  ),
                );
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    // Jika form valid, lanjut ke halaman berikutnya
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

  Future<void> fetchSurat() async {
    try {
      var response =
          await API().getdatadetailpengajuansurat(idsurat: widget.idsurat);
      ();
      if (response.statusCode == 200) {
        // print(response.data['data']);
        setState(() {
          dataModel =
              SuratLampiranModel.fromJson(response.data['data']['surat']);
          isLoading = false;
          if (dataModel?.fields != null) {
            fieldControllers = List.generate(
              dataModel!.fields.length,
              (_) => TextEditingController(),
            );
          }
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchUser() async {
    try {
      var response = await API().profiledata(nik: widget.nik);
      // print(response);
      if (response.statusCode == 200) {
        setState(() {
          dataModelUser = MasyarakatModel.fromJson(response.data['data']);
          // isLoading = false;
          // print('DATA MODEL:\n$dataModel');
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
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
        SnackBar(content: Text('File untuk Pengantar telah dipilih')),
      );
    }
  }

  Future<void> _pickLampiranFile(String idLampiran) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
      withData: true,
    );

    if (result != null) {
      File file = File(result.files.single.path!);

      setState(() {
        lampiranFiles[idLampiran] = file; // Add selected file to the map
      });

      // Show snack bar to confirm the upload
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('File untuk lampiran ${idLampiran} telah dipilih')),
      );
    }
  }

  void _submitPengajuan() async {
    final isKtpKosong =
        dataModelUser?.ktpgambar == null || dataModelUser?.ktpgambar == "";
    final isKkKosong = dataModelUser?.kartuKeluarga?.kkgambar == null ||
        dataModelUser?.kartuKeluarga?.kkgambar == "";

    // Validasi file KK dan KTP wajib ada
    if (isKtpKosong || isKkKosong) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Perhatian"),
          content: Text(
              "Harap unggah file KTP dan KK terlebih dahulu sebelum melanjutkan."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InformasiDiriPage(),
                  ),
                );
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      for (final item in dataModel!.lampiransurat) {
        if (!lampiranFiles.containsKey(item.idLampiran.toString())) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Mohon upload file untuk lampiran ${item.lampiran.namaLampiran}')),
          );
          return; //
        }
      }

      FormData formData = FormData();
      formData = FormData.fromMap({
        'id_surat': widget.idsurat,
        'nik': widget.nik,
      });
      if (_selectedFile != null) {
        formData.files.add(
          MapEntry(
            'pengantar_rt',
            await MultipartFile.fromFile(
              _selectedFile!.path,
              filename: _fileName,
            ),
          ),
        );
      }
      for (int i = 0; i < dataModel!.fields.length; i++) {
        final value = fieldControllers[i].text;
        final idField = dataModel!.fields[i].id;
        formData.fields.add(MapEntry('field_$idField', value));
      }

      // Tambahkan file dari lampiransurat
      for (final item in dataModel!.lampiransurat) {
        if (lampiranFiles.containsKey(item.idLampiran.toString())) {
          final file = lampiranFiles[item.idLampiran.toString()]!;
          formData.files.add(
            MapEntry(
              'lampiran_${item.idLampiran}',
              await MultipartFile.fromFile(
                file.path,
                filename: file.path.split('/').last,
              ),
            ),
          );
        }
      }

      var response = await API().kirimKeDio(formData: formData);
      print(response);
      if (response.statusCode == 200) {
        print("Pengajuan berhasil: ${response.data}");
        // Bisa tampilkan notifikasi atau redirect
      } else {
        print("Gagal mengirim: ${response.statusCode}");
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Isi Data Pengajuan:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    // Halaman 1
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildBiodataCard(),
                          _buildImageCard("Dokumen Kartu Keluarga",
                              "http://192.168.100.205:8000/storage/pengantar_rt/iwCtfv0nhjOZIu7OteDUqiZs5V3nAmUzbWmI5MtE.jpg"),
                          _buildImageCard("Dokumen KTP",
                              "http://192.168.100.205:8000/storage/pengantar_rt/iwCtfv0nhjOZIu7OteDUqiZs5V3nAmUzbWmI5MtE.jpg"),
                          SizedBox(
                            width: double.infinity, // Mengatur lebar Container
                            child: Card(
                              elevation: 0,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Upload File Pengantar Rt (Opsional):",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    if (_selectedFile != null)
                                      Column(
                                        children: [
                                          Text("File Terpilih: $_fileName",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(height: 10),
                                          if (_fileName != null &&
                                              (_fileName!.endsWith('.jpg') ||
                                                  _fileName!.endsWith('.png')))
                                            _selectedFile != null
                                                ? Image.file(
                                                    _selectedFile!,
                                                    height: 100,
                                                  )
                                                : Container(),
                                        ],
                                      )
                                    else
                                      Text("Belum ada file yang dipilih",
                                          style: TextStyle(color: Colors.grey)),
                                    SizedBox(height: 10),
                                    ElevatedButton.icon(
                                      onPressed: _pickPengantarFile,
                                      icon: Icon(Icons.upload_file),
                                      label: Text("Upload Foto Pengantar Rt"),
                                    ),
                                    if (PengantarRtgambar != null)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: Text(
                                          "Gambar Pengantar Rt telah dipilih!",
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Center(
                            child: ElevatedButton(
                              onPressed: (dataModel?.fields.isEmpty == true &&
                                      dataModel?.lampiransurat.isEmpty == true)
                                  ? _submitPengajuan
                                  : nextPage,
                              child: Text((dataModel?.fields.isEmpty == true &&
                                      dataModel?.lampiransurat.isEmpty == true)
                                  ? "Ajukan Surat"
                                  : "Selanjutnya"),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Halaman 2
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          if (isLoading || dataModel?.fields.isEmpty == true)
                            Center(child: CircularProgressIndicator())
                          else
                            Column(
                              children:
                                  List.generate(dataModel!.fields.length, (i) {
                                final item = dataModel!.fields[i];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: CustomTextField(
                                    controller: fieldControllers[i],
                                    labelText: item.namaField ?? "data",
                                    hintText:
                                        "Masukkan ${item.namaField ?? 'data'}",
                                    keyboardType: TextInputType.text,
                                    validator: (value) =>
                                        value == null || value.isEmpty
                                            ? 'Field ini tidak boleh kosong'
                                            : null,
                                  ),
                                );
                              }),
                            ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: prevPage,
                                child: const Text("Kembali"),
                              ),
                              ElevatedButton(
                                onPressed:
                                    (dataModel?.lampiransurat.isEmpty == true)
                                        ? _submitPengajuan
                                        : nextPage,
                                child: Text(
                                    (dataModel?.lampiransurat.isEmpty == true)
                                        ? "Ajukan Surat"
                                        : "Selanjutnya"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Halaman 3
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          if (isLoading)
                            Center(child: CircularProgressIndicator())
                          else
                            Column(
                              children: dataModel!.lampiransurat.map((item) {
                                return Column(
                                  children: [
                                    Card(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: ListTile(
                                        title: Text(item.lampiran.namaLampiran),
                                        subtitle: Text("Belum ada gambar"),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.upload),
                                          onPressed: () => _pickLampiranFile(
                                              item.idLampiran.toString()),
                                        ),
                                      ),
                                    ),
                                    const Divider(height: 1),
                                  ],
                                );
                              }).toList(),
                            ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: prevPage,
                                child: const Text("Kembali"),
                              ),
                              ElevatedButton(
                                onPressed: _submitPengajuan,
                                child: const Text("Ajukan Surat"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBiodataCard() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Biodata Warga",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildBiodataItem("NIK", dataModelUser?.nik ?? "N/A"),
            _buildBiodataItem("Nama", dataModelUser?.namaLengkap ?? "N/A"),
            _buildBiodataItem(
                "Jenis Kelamin", dataModelUser?.jenisKelamin ?? "N/A"),
            _buildBiodataItem("Tempat, Tgl Lahir",
                "${dataModelUser?.tempatLahir ?? 'N/A'}, ${dataModelUser?.tanggalLahir ?? 'N/A'}"),
            _buildBiodataItem(
                "Alamat", dataModelUser?.kartuKeluarga?.alamat ?? "N/A"),
            _buildBiodataItem("No HP", dataModelUser?.user?.nohp ?? "N/A"),
            _buildBiodataItem("Email", dataModelUser?.user?.email ?? "N/A"),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCard(String title, String img) {
    return SizedBox(
      width: double.infinity, // Mengatur lebar Container
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Image.network(img, fit: BoxFit.cover)
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
