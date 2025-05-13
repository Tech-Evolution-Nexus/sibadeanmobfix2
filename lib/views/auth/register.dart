import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../methods/api.dart';
import '../../widgets/costum_texfield.dart';

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
                  "Lengkapi input berikut untuk mendaftarkan data anda",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 500,
                        child: PageView(
                          controller: _pageController,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
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
                                ElevatedButton(
                                  onPressed: nextPage,
                                  child: Text("Selanjutnya"),
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
                                CustomTextField(
                                  controller: alamatController,
                                  labelText: "Alamat",
                                  hintText: "Masukkan alamat lengkap",
                                  validator: (value) => value!.isEmpty
                                      ? "Alamat wajib diisi"
                                      : null,
                                ),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CustomTextField(
                                              controller: rtController,
                                              labelText: "RT",
                                              hintText: "Rt",
                                              validator: (value) =>
                                                  value!.isEmpty
                                                      ? "Rt wajib diisi"
                                                      : null,
                                            ),
                                          ),
                                          SizedBox(
                                              width:
                                                  10), // kasih jarak antara RT dan RW
                                          Expanded(
                                            child: CustomTextField(
                                              controller: rwController,
                                              labelText: "Rw",
                                              hintText: "Masukkan Rw",
                                              validator: (value) =>
                                                  value!.isEmpty
                                                      ? "Rw wajib diisi"
                                                      : null,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ]),
                                SizedBox(height: 10),
                                ElevatedButton.icon(
                                  onPressed: pickImage,
                                  icon: Icon(Icons.upload_file),
                                  label: Text("Upload Foto KK"),
                                ),
                                if (kkGambar != null || kkGambarBytes != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Text(
                                      "Gambar KK telah dipilih!",
                                      style: TextStyle(color: Colors.green),
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
                                        tanggalLahirController.text =
                                            formattedDate;
                                      });
                                    }
                                  },
                                ),
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
                                  validator: (value) => value == null
                                      ? "Agama wajib dipilih"
                                      : null,
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
      ),
    );
  }
}
