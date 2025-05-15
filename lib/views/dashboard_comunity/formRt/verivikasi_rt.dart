import 'package:flutter/material.dart';
import 'package:sibadeanmob_v2_fix/models/MasyarakatModel.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/formRt/detail_rt.dart';


class VerifikasiPage extends StatelessWidget {
  final List<MasyarakatModel> semuaWarga;

  const VerifikasiPage({Key? key, required this.semuaWarga}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filter hanya yang user.status == "pending"
    final wargaBelumVerifikasi = semuaWarga.where((w) => w.user?.status == "pending").toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Verifikasi Warga')),
      body: ListView.builder(
        itemCount: wargaBelumVerifikasi.length,
        itemBuilder: (context, index) {
          final warga = wargaBelumVerifikasi[index];
          return ListTile(
            title: Text(warga.namaLengkap),
            subtitle: Text('NIK: ${warga.nik}'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailMasyarakatPage(
                    masyarakat: warga,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
