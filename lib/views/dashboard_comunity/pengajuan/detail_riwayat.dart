import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sibadeanmob_v2_fix/models/PengajuanModel.dart';

import '/methods/api.dart';

class DetailRiwayat extends StatefulWidget {
  final int idPengajuan;
  const DetailRiwayat({super.key, required this.idPengajuan});

  @override
  State<DetailRiwayat> createState() => _DetailRiwayatState();
}

class _DetailRiwayatState extends State<DetailRiwayat> {
  PengajuanSurat? pengajuanData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await API()
          .getRiwayatPengajuanDetail(idPengajuan: widget.idPengajuan);

      if (response.statusCode == 200) {
        setState(() {
          pengajuanData = PengajuanSurat.fromJson(response.data["data"]);
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Visibility(
          visible: pengajuanData?.status == "selesai",
          child: Container(
            width: 60,
            height: 60,
            child: FloatingActionButton(
              backgroundColor: const Color.fromRGBO(82, 170, 94, 1.0),
              tooltip: 'Unduh Surat',
              onPressed: () {},
              shape: const CircleBorder(), // memastikan bentuk lingkaran
              child: const Icon(Icons.download, color: Colors.white, size: 28),
            ),
          )),
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        title: Text("Detail Pengajuan",
            style: TextStyle(color: Colors.black, fontSize: 16)),
        backgroundColor: Colors.white,
        shadowColor: Colors.black.withOpacity(0.1),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : pengajuanData == null
              ? Center(child: Text("Data tidak tersedia."))
              : Container(
                  width: double.infinity,
                  child: ListView(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: Colors.black26,
                                    width: 0.2,
                                  ),
                                ),
                                elevation: 0,
                                color: Colors.white,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color:
                                            _warnaStatus(pengajuanData!.status),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      child: Row(
                                        children: [
                                          Icon(
                                            _iconStatus(pengajuanData!.status),
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              formatStatus(
                                                  pengajuanData!.status),
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Informasi Pengajuan",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          _infoItem("Nama Surat",
                                              pengajuanData!.surat.nama_surat),
                                          _infoItem("Nomor Surat",
                                              pengajuanData!.nomorSurat ?? ""),
                                          // SizedBox(height: 8),
                                          _infoItem(
                                            "Tanggal Pengajuan",
                                            formatTanggal(
                                                pengajuanData!.createdAt),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Gap(12),
                              Card(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("Data Masyarakat",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600)),
                                      SizedBox(height: 16),
                                      _infoItem(
                                          "Nama Lengkap",
                                          pengajuanData!
                                              .masyarakat.namaLengkap),
                                      _infoItem(
                                          "NIK", pengajuanData!.masyarakat.nik),
                                      _infoItem(
                                          "Jenis Kelamin",
                                          pengajuanData!
                                              .masyarakat.jenisKelamin),
                                      _infoItem(
                                          "Tempat Lahir",
                                          pengajuanData!
                                              .masyarakat.tempatLahir),
                                      _infoItem(
                                          "Tanggal Lahir",
                                          formatTanggal(pengajuanData!
                                              .masyarakat.tanggalLahir)),
                                      _infoItem("Agama",
                                          pengajuanData!.masyarakat.agama),
                                      _infoItem("Pendidikan",
                                          pengajuanData!.masyarakat.pendidikan),
                                      _infoItem("Pekerjaan",
                                          pengajuanData!.masyarakat.pekerjaan),
                                      _infoItem(
                                          "Status Perkawinan",
                                          pengajuanData!
                                              .masyarakat.statusPerkawinan),
                                      _infoItem(
                                          "Kewarganegaraan",
                                          pengajuanData!
                                              .masyarakat.kewarganegaraan),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )),
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
            flex: 3,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
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
      case 'di_terima_rw':
        return "Diterima RT, menunggu RW";
      case 'di_terima_rt':
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

  Color _warnaStatus(String status) {
    switch (status) {
      case 'selesai':
        return Colors.green;
      case 'di_tolak_rt':
      case 'di_tolak_rw':
      case 'di_tolak_lurah':
      case 'dibatalkan':
        return Colors.red;
      case 'pending':
      case 'di_terima_rw':
      case 'di_terima_rt':
      case 'di_terima_lurah':
        return Colors.orange;
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
