import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sibadeanmob_v2_fix/helper/constant.dart';
import '../../methods/api.dart';
import '../../widgets/costum_texfield.dart';

class RegisterScreen extends StatefulWidget {
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

  String? selectedGender;
  String? selectedAgama;

  // Image File
  File? kkGambar;
  Uint8List? kkGambarBytes;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      debugPrint("Tidak ada gambar yang dipilih.");
      return;
    }

    if (kIsWeb) {
      kkGambarBytes = await image.readAsBytes();
      debugPrint("Gambar berhasil dipilih (Web)");
    } else {
      kkGambar = File(image.path);
      debugPrint("Gambar berhasil dipilih (Mobile)");
    }

    setState(() {});
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

    try {
      var response = await API().registerUser(
        fullName: fullNameController.text,
        nik: nikController.text,
        noKk: noKkController.text,
        tempatLahir: tempatLahirController.text,
        tanggalLahir: tanggalLahirController.text,
        jenisKelamin: selectedGender!,
        alamat: alamatController.text,
        pekerjaan: pekerjaanController.text,
        agama: selectedAgama!,
        phone: phoneController.text,
        email: emailController.text,
        password: passwordController.text,
        kkGambar: kIsWeb ? kkGambarBytes : kkGambar,
      );

      // debugPrint("Response dari API: ${response.body}");

      // var jsonResponse = jsonDecode(response.body);
      // String message = jsonResponse['message'] ??
      //     jsonResponse['error'] ??
      //     "Pendaftaran berhasil";

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text(message), backgroundColor: Colors.green),
      // );
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Image.asset(
                  'assets/images/register.png',
                  height: deviceWidth * 0.5,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Registrasi",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
              const Text(
                "Lengkapi input berikut untuk mendaftarkan data anda",
                style: TextStyle(
                    fontSize: 16, color: Color.fromARGB(179, 5, 5, 5)),
                textAlign: TextAlign.start,
              ),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: PageView(
                    controller: _pageController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: fullNameController,
                              labelText: "Nama Lengkap",
                              hintText: "Masukkan nama lengkap",
                              validator: (value) => value!.isEmpty
                                  ? "Nama lengkap wajib diisi"
                                  : null,
                            ),
                            const SizedBox(height: 10),
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
                              controller: noKkController,
                              labelText: "No KK",
                              hintText: "Masukkan No KK",
                              keyboardType: TextInputType.number,
                              validator: (value) => value!.length != 16
                                  ? "No KK harus 16 digit"
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
                            TextFormField(
                              controller: tanggalLahirController,
                              decoration: InputDecoration(
                                labelText: "Tanggal Lahir",
                                hintText: "Pilih tanggal lahir",
                              ),
                              readOnly: true,
                              onTap: () async {
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
                                  setState(() {
                                    tanggalLahirController.text = formattedDate;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Text("Data Tambahan",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: "Jenis Kelamin",
                                hintText: "Pilih jenis kelamin",
                              ),
                              value: selectedGender,
                              items: ["Laki-laki", "Perempuan"]
                                  .map((e) => DropdownMenuItem(
                                      value: e, child: Text(e)))
                                  .toList(),
                              onChanged: (value) =>
                                  setState(() => selectedGender = value),
                              validator: (value) => value == null
                                  ? "Jenis kelamin wajib dipilih"
                                  : null,
                            ),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: "Agama",
                                hintText: "Pilih agama",
                              ),
                              value: selectedAgama,
                              items: [
                                "Islam",
                                "Kristen",
                                "Katolik",
                                "Hindu",
                                "Buddha",
                                "Konghucu"
                              ]
                                  .map((e) => DropdownMenuItem(
                                      value: e, child: Text(e)))
                                  .toList(),
                              onChanged: (value) =>
                                  setState(() => selectedAgama = value),
                              validator: (value) =>
                                  value == null ? "Agama wajib dipilih" : null,
                            ),
                            CustomTextField(
                              controller: alamatController,
                              labelText: "Alamat",
                              hintText: "Masukkan alamat lengkap",
                              validator: (value) =>
                                  value!.isEmpty ? "Alamat wajib diisi" : null,
                            ),
                            CustomTextField(
                              controller: pekerjaanController,
                              labelText: "Pekerjaan",
                              hintText: "Masukkan pekerjaan",
                              validator: (value) => value!.isEmpty
                                  ? "Pekerjaan wajib diisi"
                                  : null,
                            ),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Text("Data Akun",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
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
                              controller: emailController,
                              labelText: "Email",
                              hintText: "Masukkan email",
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) => !value!.contains('@')
                                  ? "Email tidak valid"
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
                            ElevatedButton(
                              onPressed: pickImage,
                              child: Text("Pilih Gambar KK"),
                            ),
                            if (kkGambar == null && kkGambarBytes == null)
                              Text("Gambar KK wajib diunggah",
                                  style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _currentPage > 0
                      ? ElevatedButton(
                          onPressed: prevPage, child: Text("Sebelumnya"))
                      : SizedBox(),
                  _currentPage < 2
                      ? ElevatedButton(
                          onPressed: nextPage, child: Text("Lanjut"))
                      : ElevatedButton(
                          onPressed: _register, child: Text("Daftar")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
