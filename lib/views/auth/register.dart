import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' hide TextDirection;
import '../../methods/api.dart';
import '../../widgets/costum_texfield.dart';
import '../../widgets/CustomDropdownField.dart';
import 'package:dio/dio.dart';


class RegisterScreen extends StatefulWidget {
  final String nik;
  const RegisterScreen({required this.nik, super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
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
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Kamera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromSource(jenis, ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Galeri'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromSource(jenis, ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImageFromSource(String jenis, ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: source,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (image == null) {
      debugPrint("Tidak ada gambar yang dipilih.");
      return;
    }

    final bytes = await image.readAsBytes();

    if (kIsWeb) {
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

    if (kkGambar == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Harap unggah gambar KK terlebih dahulu."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    FormData formData = FormData.fromMap({
      "nama_lengkap": fullNameController.text,
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
      "kk_gambar": kkGambar != null
          ? await MultipartFile.fromFile(kkGambar!.path, filename: "kk.jpg")
          : null,
      "ktp_gambar": ktpGambar != null
          ? await MultipartFile.fromFile(ktpGambar!.path, filename: "ktp.jpg")
          : null,
    });
    // print(formData.fields);

    try {
      var response = await API().registerUser(formData: formData);
      print(response.statusCode);
      print(response.data);

      if (response.statusCode == 200) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal registrasi")),
        );
      }
      // var jsonResponse = jsonDecode(response.body);
      // String message = jsonResponse['message'] ??
      //     jsonResponse['error'] ??
      //     "Pendaftaran berhasil";

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text(message), backgroundColor: Colors.green),
      // );
    } catch (e) {
      print("Error saat mendaftar: $e");
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
                                  prefixIcon: Icons.person,
                                ),
                                SizedBox(height: 10),
                                CustomTextField(
                                  controller: nikController,
                                  labelText: "NIK",
                                  hintText: "Masukkan NIK",
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  keyboardType: TextInputType.number,
                                  maxLength: 16,
                                  validator: (value) => value!.length != 16
                                      ? "NIK harus 16 digit"
                                      : null,
                                  prefixIcon: Icons.badge, // contoh icon
                                ),
                                CustomTextField(
                                  controller: tempatLahirController,
                                  labelText: "Tempat Lahir",
                                  hintText: "Masukkan tempat lahir",
                                  validator: (value) => value!.isEmpty
                                      ? "Tempat lahir wajib diisi"
                                      : null,
                                  prefixIcon:
                                      Icons.location_city, // contoh icon
                                ),

                                CustomTextField(
                                  controller: tanggalLahirController,
                                  labelText: "Tanggal Lahir",
                                  hintText: "Pilih tanggal lahir",
                                  readOnly: true,
                                  prefixIcon: Icons.calendar_today,
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
                                      tanggalLahirController.text =
                                          formattedDate;
                                    }
                                  },
                                ),
<<<<<<< HEAD
                               
=======

>>>>>>> b44bea0284575e4c266c86c1736cc9564cba8af4
                                CustomDropdownField(
                                  labelText: "Jenis Kelamin",
                                  hintText: "Pilih jenis kelamin",
                                  value: selectedGender,
                                  items: const [
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
                                  icon: Icons.male,
                                  validator: (value) => value == null
                                      ? "Jenis kelamin wajib dipilih"
                                      : null,
                                ),
                                CustomDropdownField(
                                  labelText: "Agama",
                                  hintText: "Pilih Agama",
                                  value: selectedAgama,
                                  items: const [
                                    DropdownMenuItem(
                                        value: "islam",
                                        child: Text("Islam")),
                                    DropdownMenuItem(
                                        value: "kristen_protestan",
                                        child: Text("Kristen Protestan")),
                                    DropdownMenuItem(
                                        value: "kristen_katolik",
                                        child: Text("Kristen Katholik")),
                                    DropdownMenuItem(
                                        value: "hindu",
                                        child: Text("Hindu")),
                                    DropdownMenuItem(
                                        value: "buddha",
                                        child: Text("Buddha")),
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
                                  icon: Icons.check_outlined,
                                  validator: (value) => value == null
                                      ? "Jenis kelamin wajib dipilih"
                                      : null,
                                ),
                                CustomTextField(
                                  controller: pekerjaanController,
                                  labelText: "Pekerjaan",
                                  hintText: "Masukkan pekerjaan",
                                  validator: (value) => value!.isEmpty
                                      ? "Pekerjaan wajib diisi"
                                      : null,
                                  prefixIcon: Icons.work,
                                ),
                                SizedBox(height: 10),
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: nextPage,
                                    child: const Text(
                                      "Selanjutnya",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
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
                                  prefixIcon: Icons.mail,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) => !value!.contains('@')
                                      ? "Email tidak valid"
                                      : null,
                                ),
                                CustomTextField(
                                  controller: phoneController,
                                  labelText: "No HP",
                                  hintText: "Masukkan nomor HP",
                                  prefixIcon: Icons.phone_android,
                                  keyboardType: TextInputType.phone,
                                  maxLength: 13,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  validator: (value) => value!.length < 12
                                      ? "Nomor HP tidak valid"
                                      : null,
                                ),
                                CustomTextField(
                                  controller: passwordController,
                                  labelText: "Password",
                                  hintText: "Masukkan password",
                                  obscureText: _obscurePassword,
                                  prefixIcon: Icons.password_rounded,
                                  suffixIcon: _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  onSuffixPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                  validator: (value) => value!.length < 6
                                      ? "Password minimal 6 karakter"
                                      : null,
                                ),
                                CustomTextField(
                                  controller: confirmPasswordController,
                                  labelText: "Konfirmasi Password",
                                  hintText: "Masukkan ulang password",
                                  obscureText: _obscureConfirmPassword,
                                  prefixIcon: Icons.password_rounded,
                                  suffixIcon: _obscureConfirmPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  onSuffixPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword = !_obscureConfirmPassword;
                                    });
                                  },
                                  validator: (value) =>
                                      value != confirmPasswordController.text
                                          ? "Password tidak cocok"
                                          : null,
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Tombol Kembali (ikon kiri)
                                    Expanded(
                                      child: SizedBox(
                                        height: 50,
                                        child: ElevatedButton.icon(
                                          onPressed: prevPage,
                                          icon: const Icon(Icons.arrow_back,
                                              color: Colors.white),
                                          label: const Text(
                                            "Kembali",
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                        width: 16), // Jarak antar tombol

                                    // Tombol Selanjutnya (ikon kanan)
                                    Expanded(
                                      child: SizedBox(
                                        height: 50,
                                        child: Directionality(
                                          textDirection: TextDirection.rtl, // Membalik posisi icon dan label
                                          child: ElevatedButton.icon(
                                            onPressed: nextPage,
                                            icon: const Icon(
                                                Icons.arrow_back,
                                                color: Colors.white),
                                            label: const Text(
                                              "Selanjutnya",
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                        
                                        ),
                                      ),
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
                                  prefixIcon: Icons.pin,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  keyboardType: TextInputType.number,
                                  maxLength: 16,
                                  validator: (value) => value!.length != 16
                                      ? "No KK harus 16 digit"
                                      : null,
                                ),
                                CustomTextField(
                                  controller: alamatController,
                                  labelText: "Alamat",
                                  hintText: "Masukkan alamat lengkap",
                                  prefixIcon: Icons.home,
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
                                        hintText: "RT",
                                        prefixIcon: Icons.person_2,
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
                                        hintText: "RW",
                                        prefixIcon: Icons.person_3,
                                        validator: (value) => value!.isEmpty
                                            ? "RW wajib diisi"
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                _buildUploadCard(
                                  label: "Klik untuk unggah Foto KK",
                                  imageFile: kkGambar,
                                  imageBytes: kkGambarBytes,
                                  onTap: () => pickImage('KK'),
                                  onClear: () => clearImage('KK'),
                                ),
                                SizedBox(height: 10),
                                _buildUploadCard(
                                  label:
                                      "Klik untuk unggah Foto KTP (opsional)",
                                  imageFile: ktpGambar,
                                  imageBytes: ktpGambarBytes,
                                  onTap: () => pickImage('KTP'),
                                  onClear: () => clearImage('KTP'),
                                ),
                                SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: _register,
                                    child: const Text(
                                      "Daftar",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: prevPage,
                                    child: const Text(
                                      "Kembali",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
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
Widget _buildUploadCard({
  required String label,
  required File? imageFile,
  required Uint8List? imageBytes,
  required VoidCallback onTap,
  required VoidCallback onClear,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      height: 160,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: imageBytes != null
                  ? Image.memory(imageBytes, fit: BoxFit.cover)
                  : imageFile != null
                      ? Image.file(imageFile, fit: BoxFit.cover)
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.cloud_upload,
                                  size: 40, color: Colors.grey),
                              SizedBox(height: 10),
                              Text(
                                "Klik untuk unggah gambar",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
            ),
          ),
          if (imageFile != null || imageBytes != null)
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: onClear,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

