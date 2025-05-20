import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../methods/api.dart';
import '../../widgets/costum_texfield.dart';
import '../../widgets/CustomDropdownField.dart';
import 'package:dio/dio.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Controllers
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
  File? ktpGambar;
  Uint8List? ktpGambarBytes;

  Future<void> pickImage(String jenis) async {
    final ImagePicker picker = ImagePicker();
    XFile? image;
    // Tentukan sumber gambar berdasarkan jenis dokumen
    if (jenis == 'KTP') {
      image = await picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
      );
    } else if (jenis == 'KK') {
      image = await picker.pickImage(
        source: ImageSource.gallery,
      );
    } else {
      debugPrint("Jenis dokumen tidak dikenali.");
      return;
    }

    if (image == null) {
      debugPrint("Tidak ada gambar yang dipilih.");
      return;
    }

    // Jika platform Web
    if (kIsWeb) {
      final bytes = await image.readAsBytes();
      setState(() {
        if (jenis == 'KTP') {
          ktpGambarBytes = bytes;
        } else if (jenis == 'KK') {
          kkGambarBytes = bytes;
        }
      });
      debugPrint("Gambar berhasil dipilih (Web)");
    } else {
      final file = File(image.path);
      final bytes = await image.readAsBytes();
      setState(() {
        if (jenis == 'KTP') {
          ktpGambar = file;
          ktpGambarBytes = bytes;
        } else if (jenis == 'KK') {
          kkGambar = file;
          kkGambarBytes = bytes;
        }
      });
      debugPrint("Gambar berhasil dipilih (Mobile)");
    }
  }

  void clearImage(String jenis) {
  setState(() {
    if (jenis == 'KK') {
      kkGambar = null;
      kkGambarBytes = null;
    } else if (jenis == 'KTP') {
      ktpGambar = null;
      ktpGambarBytes = null;
    }
  });
}

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

  Future<void> _register() async {
    debugPrint("Tombol daftar ditekan!");

    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Harap isi semua data dengan benar.")),
      );
      return;
    }

    if (kkGambar == null && kkGambarBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Harap unggah gambar KK terlebih dahulu."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (ktpGambar == null && ktpGambarBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Harap unggah gambar KTP terlebih dahulu."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    FormData formData = FormData();

    formData = FormData.fromMap({
      "full_name": fullNameController.text,
      "nik": nikController.text,
      "tempat_lahir": tempatLahirController.text,
      "tanggal_lahir": tanggalLahirController.text,
      "jenis_kelamin": selectedGender,
      "agama": selectedAgama,
      "pekerjaan": pekerjaanController.text,
      "email": emailController.text,
      "no_hp": phoneController.text,
      "password": passwordController.text,
      "no_kk": noKkController.text,
      "alamat": alamatController.text,
      "rt": rtController.text,
      "rw": rwController.text,
      "foto_kk": kkGambar,
      "foto_ktp": ktpGambar, // bisa null, tergantung validasi kamu
    });

    try {
      var response = await API().registerUser(formData: formData);
      // Kalau mau cek response dari API:
      debugPrint("Response dari API: ${response.body}");

      var jsonResponse = jsonDecode(response.body);
      String message = jsonResponse['message'] ??
          jsonResponse['error'] ??
          "Pendaftaran berhasil";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green),
      );
    } catch (e) {
      debugPrint("Error saat mendaftar: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan, coba lagi nanti.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    child: Image.asset(
                      'assets/images/register.png',
                      height: deviceWidth * 0.5,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Text(
                  "Registrasi",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  "Lengkapi data anda sebelum mendaftar di Aplikasi E-Surat Badean.",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.8,
                        ),
                        child: PageView(
                          controller: _pageController,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            // STEP 1: Identitas Diri
                            Column(
                              children: [
                                CustomTextField(
                                  controller: fullNameController,
                                  labelText: "Nama Lengkap",
                                  hintText: "Masukkan nama lengkap",
                                  validator: (value) => value!.isEmpty
                                      ? "Nama wajib diisi"
                                      : null,
                                ),
                                SizedBox(height: 10),
                                CustomTextField(
                                  controller: nikController,
                                  labelText: "NIK",
                                  hintText: "Masukkan NIK",
                                  keyboardType: TextInputType.number,
                                  validator: (value) => value!.length != 16
                                      ? "NIK harus 16 digit"
                                      : null,
                                ),
                                CustomTextField(
                                  controller: tempatLahirController,
                                  labelText: "Tempat Lahir",
                                  hintText: "Masukkan tempat lahir",
                                  validator: (value) => value!.isEmpty
                                      ? "Tempat lahir wajib diisi"
                                      : null,
                                ),
                                CustomTextField(
                                  controller: tanggalLahirController,
                                  labelText: "Tanggal Lahir",
                                  hintText: "Pilih tanggal lahir",
                                  readOnly: true,
                                  suffixIcon: Icons.calendar_today,
                                  onSuffixPressed: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime.now(),
                                    );

                                    if (pickedDate != null) {
                                      String formattedDate =
                                          DateFormat('dd-MM-yyyy')
                                              .format(pickedDate);
                                      tanggalLahirController.text =
                                          formattedDate;
                                    }
                                  },
                                ),
                                CustomDropdownField(
                                  labelText: "Jenis Kelamin",
                                  hintText: "Pilih jenis kelamin",
                                  value: selectedGender,
                                  items: [
                                    DropdownMenuItem(
                                        value: "laki-laki",
                                        child: Text("Laki-laki")),
                                    DropdownMenuItem(
                                        value: "perempuan",
                                        child: Text("Perempuan")),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGender = value;
                                    });
                                  },
                                ),
                                CustomDropdownField(
                                  labelText: "Agama",
                                  hintText: "Pilih Agama",
                                  value: selectedAgama,
                                  items: [
                                    DropdownMenuItem(
                                        value: "islam", child: Text("Islam")),
                                    DropdownMenuItem(
                                        value: "kristen_protestan",
                                        child: Text("Kristen")),
                                    DropdownMenuItem(
                                        value: "kristen_katolik",
                                        child: Text("Katholik")),
                                    DropdownMenuItem(
                                        value: "hindu", child: Text("Hindu")),
                                    DropdownMenuItem(
                                        value: "buddha", child: Text("Buddha")),
                                    DropdownMenuItem(
                                        value: "konghucu",
                                        child: Text("Khonghucu")),
                                    DropdownMenuItem(
                                        value: "lainnya",
                                        child: Text("Lainnya")),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedAgama = value;
                                    });
                                  },
                                ),
                                CustomTextField(
                                  controller: pekerjaanController,
                                  labelText: "Pekerjaan",
                                  hintText: "Masukkan pekerjaan",
                                  validator: (value) => value!.isEmpty
                                      ? "Pekerjaan wajib diisi"
                                      : null,
                                ),
                                SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: nextPage,
                                  child: Text("Selanjutnya"),
                                ),
                              ],
                            ),

                            // STEP 2: Akun
                            Column(
                              children: [
                                CustomTextField(
                                  controller: emailController,
                                  labelText: "Email",
                                  hintText: "Masukkan email",
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) => !value!.contains('@')
                                      ? "Email tidak valid"
                                      : null,
                                ),
                                CustomTextField(
                                  controller: phoneController,
                                  labelText: "No HP",
                                  hintText: "Masukkan nomor HP",
                                  keyboardType: TextInputType.phone,
                                  validator: (value) => value!.length < 10
                                      ? "Nomor HP tidak valid"
                                      : null,
                                ),
                                CustomTextField(
                                  controller: passwordController,
                                  labelText: "Password",
                                  hintText: "Masukkan password",
                                  obscureText: true,
                                  validator: (value) => value!.length < 6
                                      ? "Password minimal 6 karakter"
                                      : null,
                                ),
                                CustomTextField(
                                  controller: confirmPasswordController,
                                  labelText: "Konfirmasi Password",
                                  hintText: "Masukkan ulang password",
                                  obscureText: true,
                                  validator: (value) =>
                                      value != passwordController.text
                                          ? "Password tidak cocok"
                                          : null,
                                ),
                                SizedBox(height: 10),
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

                            // STEP 3: Alamat dan Upload KK
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
                                CustomTextField(
                                  controller: alamatController,
                                  labelText: "Alamat",
                                  hintText: "Masukkan alamat lengkap",
                                  validator: (value) => value!.isEmpty
                                      ? "Alamat wajib diisi"
                                      : null,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextField(
                                        controller: rtController,
                                        labelText: "RT",
                                        hintText: "Rt",
                                        validator: (value) => value!.isEmpty
                                            ? "RT wajib diisi"
                                            : null,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: CustomTextField(
                                        controller: rwController,
                                        labelText: "RW",
                                        hintText: "Rw",
                                        validator: (value) => value!.isEmpty
                                            ? "RW wajib diisi"
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                GestureDetector(
                                  onTap: () => pickImage('KK'),
                                  child: Container(
                                    width: double.infinity,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned.fill(
                                          child: kkGambarBytes != null
                                              ? Image.memory(kkGambarBytes!,
                                                  fit: BoxFit.cover)
                                              : kkGambar != null
                                                  ? Image.file(kkGambar!,
                                                      fit: BoxFit.cover)
                                                  : Center(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: const [
                                                          Icon(
                                                              Icons.upload_file,
                                                              size: 30,
                                                              color:
                                                                  Colors.grey),
                                                          SizedBox(height: 8),
                                                          Text(
                                                              "Klik untuk unggah Foto KK"),
                                                        ],
                                                      ),
                                                    ),
                                        ),
                                        if (kkGambar != null ||
                                            kkGambarBytes != null)
                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: GestureDetector(
                                              onTap: () => clearImage('KK'),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(Icons.delete,
                                                    color: Colors.white,
                                                    size: 30),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(height: 10),
                                GestureDetector(
                                  onTap: () => pickImage('KTP'),
                                  child: Container(
                                    width: double.infinity,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned.fill(
                                          child: ktpGambarBytes != null
                                              ? Image.memory(ktpGambarBytes!,
                                                  fit: BoxFit.cover)
                                              : ktpGambar != null
                                                  ? Image.file(ktpGambar!,
                                                      fit: BoxFit.cover)
                                                  : Center(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: const [
                                                          Icon(
                                                              Icons.upload_file,
                                                              size: 30,
                                                              color:
                                                                  Colors.grey),
                                                          SizedBox(height: 8),
                                                          Text(
                                                              "Klik untuk unggah Foto KTP"),
                                                        ],
                                                      ),
                                                    ),
                                        ),
                                        if (ktpGambar != null ||
                                            ktpGambarBytes != null)
                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: GestureDetector(
                                              onTap: () => clearImage('KTP'),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(Icons.delete,
                                                    color: Colors.white,
                                                    size: 30),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _register,
                                  child: Text("Daftar"),
                                ),
                                TextButton(
                                  onPressed: prevPage,
                                  child: Text("Kembali"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ], //disini
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
