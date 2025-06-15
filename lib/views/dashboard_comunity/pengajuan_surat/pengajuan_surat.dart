import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sibadeanmob_v2_fix/methods/api.dart';
import 'package:sibadeanmob_v2_fix/methods/auth.dart';
import 'package:sibadeanmob_v2_fix/models/MasyarakatModel.dart';
import 'package:sibadeanmob_v2_fix/models/suratlampiranmodel.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/profiles/informasi_diri.dart';
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
  Map<String, String> lampiranFileNames = {};
  // Image File
  File? _selectedFile;
  // Uint8List? _selectedFileBytes;
  String? _fileName;
  // Uint8List? PengantarRtgambarBytes;
  File? PengantarRtgambar;
  final TextEditingController ketController = TextEditingController();
  Map<String, bool> _expandedStates = {};

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
    if (isKkKosong) {
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
      // ();
      if (response.statusCode == 200) {
        print(response.data['data']['surat']['fields']);
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
          print(dataModel?.fields);
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

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      String fileName = result.files.single.name;

      setState(() {
        lampiranFiles[idLampiran] = file;
        lampiranFileNames[idLampiran] = fileName; // <- Tambahkan ini
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('File untuk lampiran $idLampiran telah dipilih'),
        ),
      );
    }
  }

  void _submitPengajuan() async {
    final isKtpKosong =
        dataModelUser?.ktpgambar == null || dataModelUser?.ktpgambar == "";
    final isKkKosong = dataModelUser?.kartuKeluarga?.kkgambar == null ||
        dataModelUser?.kartuKeluarga?.kkgambar == "";

    // Validasi file KK dan KTP wajib ada
    if (isKkKosong) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Perhatian"),
          content:
              Text("Harap unggah file KK terlebih dahulu sebelum melanjutkan."),
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

      var user = await Auth.user();
      FormData formData = FormData();
      formData = FormData.fromMap({
        'id_surat': widget.idsurat,
        'nik': widget.nik,
        'nik_pemohon': user['nik'],
        'keterangan': ketController.text.trim()
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
      if (response.statusCode == 200) {
        // print("Arahkan ke dashboard: ${user['role']}");
        Navigator.of(context).pop();
        Navigator.of(context).pop();

        // if (Navigator.of(context).canPop()) {
        //   Navigator.of(context).pop();
        // } else {
        //   // Jika tidak bisa pop, arahkan ke halaman utama atau gunakan goRouter pushReplacement
        //   context.go('/beranda'); // atau sesuai dengan rute utama kamu
        // }
      } else {
        print(response.data);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal Melakukan Pengajuan")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Mohon lengkapi semua data")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pengajuan ${widget.namaSurat ?? ''}",
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                                SizedBox(
                                    width: double.infinity,
                                    child: Card(
                                      elevation: 0,
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 12),
                                      child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Keterangan Pengajuan Surat",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              CustomTextField(
                                                labelText:
                                                    "Keterangan Pengajuan Surat",
                                                hintText:
                                                    "Masukkan Alasan Pengajuan",
                                                controller: ketController,
                                                keyboardType:
                                                    TextInputType.text,
                                                prefixIcon:
                                                    Icons.card_membership,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Masukkan Keterangan Pengajuan Surat Anda';
                                                  }
                                                },
                                              ),
                                            ],
                                          )),
                                    )),
                                _buildImageCard(
                                  "Dokumen Kartu Keluarga",
                                  dataModelUser?.kartuKeluarga?.kkgambar ?? '',
                                ),
                                _buildImageCard(
                                  "Dokumen KTP",
                                  dataModelUser?.ktpgambar ?? '',
                                ),
                                GestureDetector(
                                  onTap: _pickPengantarFile,
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 250,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey.shade400,
                                            style: BorderStyle.solid,
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: Colors.grey.shade50,
                                          image: _selectedFile != null &&
                                                  (_fileName
                                                              ?.toLowerCase()
                                                              .endsWith(
                                                                  '.jpg') ==
                                                          true ||
                                                      _fileName
                                                              ?.toLowerCase()
                                                              .endsWith(
                                                                  '.jpeg') ==
                                                          true ||
                                                      _fileName
                                                              ?.toLowerCase()
                                                              .endsWith(
                                                                  '.png') ==
                                                          true)
                                              ? DecorationImage(
                                                  image:
                                                      FileImage(_selectedFile!),
                                                  fit: BoxFit.cover,
                                                )
                                              : null,
                                        ),
                                        child: _selectedFile == null
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.cloud_upload_outlined,
                                                    size: 40,
                                                    color: Colors.blueAccent,
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    _fileName ??
                                                        "Klik untuk memilih file",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color:
                                                          Colors.grey.shade600,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  _fileName ?? '',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    backgroundColor:
                                                        Colors.black38,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                      ),

                                      /// Tombol Hapus Preview
                                      if (_selectedFile != null)
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: IconButton(
                                            icon: const Icon(Icons.close,
                                                color: Colors.red),
                                            onPressed: () {
                                              setState(() {
                                                _selectedFile = null;
                                                _fileName = null;
                                                PengantarRtgambar = null;
                                              });
                                            },
                                            tooltip: 'Hapus file',
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed:
                                        (dataModel?.fields?.isEmpty ?? true) &&
                                                (dataModel?.lampiransurat
                                                        ?.isEmpty ??
                                                    true)
                                            ? _submitPengajuan
                                            : nextPage,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 16),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 6,
                                      shadowColor: Colors.black45,
                                      textStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    child: Text(
                                      (dataModel?.fields?.isEmpty ?? true) &&
                                              (dataModel?.lampiransurat
                                                      ?.isEmpty ??
                                                  true)
                                          ? "Ajukan Surat"
                                          : "Selanjutnya",
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                          if ((dataModel?.fields?.isNotEmpty ?? false))
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  if (isLoading ||
                                      (dataModel?.fields?.isEmpty ?? true))
                                    Center(child: CircularProgressIndicator())
                                  else
                                    Column(
                                      children: List.generate(
                                          dataModel!.fields.length, (i) {
                                        final item = dataModel!.fields[i];
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 12.0),
                                          child: CustomTextField(
                                            controller:
                                                fieldControllers.length > i
                                                    ? fieldControllers[i]
                                                    : TextEditingController(),
                                            labelText: item.namaField ?? "data",
                                            hintText:
                                                "Masukkan ${item.namaField ?? 'data'}",
                                            keyboardType: TextInputType.text,
                                            validator: (value) => value ==
                                                        null ||
                                                    value.isEmpty
                                                ? 'Field ini tidak boleh kosong'
                                                : null,
                                          ),
                                        );
                                      }),
                                    ),
                                  SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: (dataModel?.lampiransurat
                                                        ?.isEmpty ??
                                                    true)
                                                ? _submitPengajuan
                                                : nextPage,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 24,
                                                      vertical: 16),
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              elevation: 6,
                                              shadowColor: Colors.black45,
                                              textStyle: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            child: Text(
                                              (dataModel?.lampiransurat
                                                          ?.isEmpty ??
                                                      true)
                                                  ? "Ajukan Surat"
                                                  : "Selanjutnya",
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: prevPage,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.grey,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 24,
                                                      vertical: 16),
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              elevation: 6,
                                              shadowColor: Colors.black45,
                                              textStyle: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            child: const Text("Kembali"),
                                          ),
                                        ),
                                      ],
                                    ),
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
                                    children: (dataModel?.lampiransurat ?? [])
                                        .map((item) {
                                      final id =
                                          item.idLampiran?.toString() ?? '';
                                      final nama =
                                          item.lampiran.namaLampiran ?? '';
                                      final file = lampiranFiles[id];
                                      final fileName = lampiranFileNames[id];

                                      final isImage = file != null &&
                                          (fileName
                                                      ?.toLowerCase()
                                                      .endsWith('.jpg') ==
                                                  true ||
                                              fileName
                                                      ?.toLowerCase()
                                                      .endsWith('.jpeg') ==
                                                  true ||
                                              fileName
                                                      ?.toLowerCase()
                                                      .endsWith('.png') ==
                                                  true);

                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 12,),
                                            Text(
                                              nama,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),
                                              
                                            ),
                                            const SizedBox(height: 8),
                                            GestureDetector(
                                              onTap: () =>
                                                  _pickLampiranFile(id),
                                              child: Container(
                                                height: 180,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: Colors.grey.shade300,
                                                  ),
                                                  color: Colors.grey.shade50,
                                                  image: isImage
                                                      ? DecorationImage(
                                                          image:
                                                              FileImage(file!),
                                                          // fit: BoxFit.cover,
                                                        )
                                                      : null,
                                                ),
                                                child: isImage
                                                    ? Stack(
                                                        children: [
                                                          Positioned(
                                                            top: 8,
                                                            right: 8,
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.6),
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child: IconButton(
                                                                icon: const Icon(
                                                                    Icons.close,
                                                                    color: Colors
                                                                        .white),
                                                                onPressed: () {
                                                                  setState(() {
                                                                    lampiranFiles
                                                                        .remove(
                                                                            id);
                                                                    lampiranFileNames
                                                                        .remove(
                                                                            id);
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : Center(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                                Icons
                                                                    .image_outlined,
                                                                size: 40,
                                                                color: Colors
                                                                    .grey
                                                                    .shade500),
                                                            const SizedBox(
                                                                height: 8),
                                                            Text(
                                                              "Belum ada gambar\n(Klik untuk unggah)",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade600,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: _submitPengajuan,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 24, vertical: 16),
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            elevation: 6,
                                            shadowColor: Colors.black45,
                                            textStyle: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          child: const Text("Ajukan Surat"),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: prevPage,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.grey,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 24, vertical: 16),
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            elevation: 6,
                                            shadowColor: Colors.black45,
                                            textStyle: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          child: const Text("Kembali"),
                                        ),
                                      ),
                                      // Jarak antar tombol
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),
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
      margin: EdgeInsets.symmetric(vertical: 8),
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
    final isExpanded = _expandedStates[title] ?? false;
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        child: InkWell(
          onTap: () {
            setState(() {
              _expandedStates[title] = !isExpanded;
            });
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                    ),
                  ],
                ),
                if (isExpanded) ...[
                  SizedBox(height: 10),
                  Image.network(
                    (img.isNotEmpty)
                        ? img
                        : 'https://dummyimage.com/500x200/f2f2f2/555555&text=No+Image',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.network(
                        'https://dummyimage.com/80x80/f2f2f2/555555&text=No+Image',
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ]
              ],
            ),
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
