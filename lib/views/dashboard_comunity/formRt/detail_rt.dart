import 'package:flutter/material.dart';
import 'package:sibadeanmob_v2_fix/models/MasyarakatModel.dart';


class DetailMasyarakatPage extends StatelessWidget {
  final MasyarakatModel masyarakat;

  const DetailMasyarakatPage({Key? key, required this.masyarakat}) : super(key: key);

  void _verifikasi(BuildContext context) {
    // Simulasi aksi verifikasi
    // Ganti dengan request ke backend jika perlu

    // Tampilkan konfirmasi berhasil
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Berhasil diverifikasi"),
        content: Text("${masyarakat.namaLengkap} sudah diverifikasi."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );

    // Di sini kamu bisa panggil API/ubah status, misalnya:
    // ApiService.verifikasiWarga(masyarakat.nik)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail Warga")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nama: ${masyarakat.namaLengkap}"),
            Text("NIK: ${masyarakat.nik}"),
            Text("No KK: ${masyarakat.noKk}"),
            Text("Jenis Kelamin: ${masyarakat.jenisKelamin}"),
            Text("Tempat Lahir: ${masyarakat.tempatLahir}"),
            Text("Tanggal Lahir: ${masyarakat.tanggalLahir}"),
            Text("Agama: ${masyarakat.agama}"),
            Text("Pendidikan: ${masyarakat.pendidikan}"),
            Text("Pekerjaan: ${masyarakat.pekerjaan}"),
            Text("Golongan Darah: ${masyarakat.golonganDarah}"),
            Text("Status Perkawinan: ${masyarakat.statusPerkawinan}"),
            if (masyarakat.tanggalPerkawinan.isNotEmpty)
              Text("Tanggal Perkawinan: ${masyarakat.tanggalPerkawinan}"),
            Text("Status Keluarga: ${masyarakat.statusKeluarga}"),
            Text("Kewarganegaraan: ${masyarakat.kewarganegaraan}"),
            Text("No Paspor: ${masyarakat.noPaspor}"),
            Text("No KITAP: ${masyarakat.noKitap}"),
            Text("Nama Ayah: ${masyarakat.namaAyah}"),
            Text("Nama Ibu: ${masyarakat.namaIbu}"),
            Text("Tanggal Pendaftaran: ${masyarakat.createdAt}"),
            const SizedBox(height: 16),
            masyarakat.ktpgambar.isNotEmpty
                ? Image.network(masyarakat.ktpgambar)
                : const Text("Tidak ada gambar KTP."),
            const SizedBox(height: 20),
            if (masyarakat.user?.status == "pending")
              ElevatedButton.icon(
                onPressed: () => _verifikasi(context),
                icon: const Icon(Icons.verified),
                label: const Text("Verifikasi Warga"),
              ),
          ],
        ),
      ),
    );
  }
}
