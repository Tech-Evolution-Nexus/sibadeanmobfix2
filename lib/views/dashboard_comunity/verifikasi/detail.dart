import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sibadeanmob_v2_fix/methods/auth.dart';
import 'package:sibadeanmob_v2_fix/models/MasyarakatModel.dart';
import 'package:sibadeanmob_v2_fix/models/PengajuanModel.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/verifikasi/verifikasi.dart';
import 'package:sibadeanmob_v2_fix/widgets/costum_texfield.dart';

import '/methods/api.dart';

class DetailVerifikasi extends StatefulWidget {
  final int idUser;
  const DetailVerifikasi({super.key, required this.idUser});

  @override
  State<DetailVerifikasi> createState() => _DetailVerifikasiState();
}

class _DetailVerifikasiState extends State<DetailVerifikasi> {
  MasyarakatModel? pengajuanData;
  bool isLoading = true;
  bool canEdit = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController keteranganController = TextEditingController();
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response =
          await API().verifikasiDetailMasyarakat(idUser: widget.idUser);
      //   print(response.data);
      if (response.statusCode == 200) {
        setState(() {
          pengajuanData = MasyarakatModel.fromJson(response.data["data"]);
          // MasyarakatModel.fromJson(response.data["data"]);
          print(pengajuanData);
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print(e);
      setState(() => isLoading = false);
    }
  }

  Future<void> submit(int status) async {
    try {
      final user = await Auth.user();
      print(keteranganController.text.trim());
      final response =
          await API().updateVerifikasi(idUser: widget.idUser, status: status);
      if (response.statusCode == 200) {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verifikasi berhasil')),
          );

          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (_) => Verifikasi()));
          // isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print(e);

      setState(() => isLoading = false);
    }
  }

  Future<void> showInputTolak() {
    return showModalBottomSheet(
      enableDrag: true,
      showDragHandle: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      context: context,
      builder: (BuildContext context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 200),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Keterangan Ditolak",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        labelText: "Keterangan Ditolak",
                        hintText: "Masukkan keterangan penolakan",
                        controller: keteranganController,
                        keyboardType: TextInputType.text,
                        validator: (value) => value!.isEmpty
                            ? 'Masukkan keterangan penolakan'
                            : null,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF052158),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              submit(0);
                            }
                          },
                          child: const Text(
                            "Kirim",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context),
        ),
        // title: Text("Detail Pengajuan",
        //     style: TextStyle(color: Colors.black, fontSize: 16)),
        backgroundColor: Colors.white,
        shadowColor: Colors.black.withOpacity(0.1),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : pengajuanData == null
              ? Center(child: Text("Data tidak tersedia."))
              : RefreshIndicator(
                  onRefresh: fetchData,
                  child: Container(
                    width: double.infinity,
                    child: ListView(
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                _masyarakat(),
                                _lampiran(),
                                SizedBox(
                                  height: 3,
                                ),
                                Visibility(
                                    visible: canEdit,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: showInputTolak,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                            ),
                                            child: Text("Tolak"),
                                          ),
                                        ),
                                        SizedBox(
                                            width: 16), // Jarak antar tombol
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              submit(1);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                            ),
                                            child: Text("Setujui"),
                                          ),
                                        ),
                                      ],
                                    ))
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _masyarakat() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.black26,
          width: .2,
        ),
      ),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Data Masyarakat",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(height: 16),
            _infoItem("Nama Lengkap", pengajuanData!.namaLengkap),
            _infoItem("NIK", pengajuanData!.nik),
            _infoItem("Jenis Kelamin", pengajuanData!.jenisKelamin),
            _infoItem("Tempat Lahir", pengajuanData!.tempatLahir),
            _infoItem(
                "Tanggal Lahir", formatTanggal(pengajuanData!.tanggalLahir)),
            _infoItem("Agama", pengajuanData!.agama),
            _infoItem("Pendidikan", pengajuanData!.pendidikan),
            _infoItem("Pekerjaan", pengajuanData!.pekerjaan),
            _infoItem("Status Perkawinan", pengajuanData!.statusPerkawinan),
            _infoItem("Kewarganegaraan", pengajuanData!.kewarganegaraan),
          ],
        ),
      ),
    );
  }

  Widget _lampiran() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.black26,
          width: .2,
        ),
      ),
      elevation: 0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Data Lampiran",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(height: 16),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Text(
            //       pengajuanData!.kartuKeluarga!.kkgambar,
            //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            //     ),
            //     SizedBox(height: 8),
            //     GestureDetector(
            //       onTap: () {
            //         showDialog(
            //           context: context,
            //           builder: (_) => Dialog(
            //             backgroundColor: Colors.transparent,
            //             child: GestureDetector(
            //               onTap: () => Navigator.pop(context),
            //               child: InteractiveViewer(
            //                 child: Image.network(
            //                   pengajuanData!.kartuKeluarga!.kkgambar,
            //                   fit: BoxFit.contain,
            //                 ),
            //               ),
            //             ),
            //           ),
            //         );
            //       },
            //       child: Card(
            //         elevation: 0,
            //         color: Colors.white,
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(12),
            //           side: BorderSide(
            //             color: Colors.black26,
            //             width: .2,
            //           ),
            //         ),
            //         // clipBehavior: Clip.antiAlias,
            //         child: Image.network(
            //           pengajuanData!.kartuKeluarga!.kkgambar,
            //           height: 150,
            //           width: double.infinity,
            //           fit: BoxFit.contain,
            //         ),
            //       ),
            //     ),
            //     SizedBox(height: 20),
            //   ],
            // )
          ],
        ),
      ),
    );
  }

  Widget _infoItem(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.grey[700],
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                color: isBold ? Colors.black : Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String formatStatus(String status) {
    switch (status) {
      case 'selesai':
        return "Selesai";
      case 'di_tolak_rt':
      case 'di_tolak_rw':
      case 'di_tolak_lurah':
        return "Ditolak";
      case 'pending':
        return "Menunggu disetujui RT";
      case 'dibatalkan':
        return "Dibatalkan";
      case 'di_terima_rt':
        return "Diterima RT, menunggu RW";
      case 'di_terima_rw':
        return "Diterima RW, menunggu Kelurahan";
      default:
        return "Menunggu disetujui RT";
    }
  }

  IconData _iconStatus(String status) {
    switch (status) {
      case 'selesai':
        return Icons.check_circle;
      case 'di_tolak_rt':
      case 'di_tolak_rw':
      case 'di_tolak_lurah':
      case 'dibatalkan':
        return Icons.cancel;
      case 'pending':
        return Icons.hourglass_top;
      default:
        return Icons.info_outline;
    }
  }

  Color _warnaStatus(int status) {
    switch (status) {
      case 1:
        return Colors.green;
      case 0:
        return Colors.blueGrey;
      default:
        return Colors.blueGrey;
    }
  }

  String formatTanggal(String tanggalISO) {
    try {
      final date = DateTime.parse(tanggalISO);
      return "${_namaHari(date.weekday)}, ${date.day} ${_namaBulan(date.month)} ${date.year}";
    } catch (_) {
      return tanggalISO;
    }
  }

  String _namaHari(int day) {
    const days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu'
    ];
    return days[day - 1];
  }

  String _namaBulan(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return months[month - 1];
  }
}
