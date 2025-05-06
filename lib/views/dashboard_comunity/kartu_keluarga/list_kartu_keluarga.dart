import 'package:flutter/material.dart';

class DaftarAnggotaKeluargaView extends StatelessWidget {
  const DaftarAnggotaKeluargaView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final anggotaKeluarga = [
      {
        'nama': 'Muhammad Abrori',
        'hubungan': 'Ayah',
        'nik': '357303030987',
      },
      {
        'nama': 'Siti Rohayu',
        'hubungan': 'Ibu',
        'nik': '357303030982',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Anggota Keluarga'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Silakan pilih anggota keluarga yang akan diajukan dalam permohonan surat.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: anggotaKeluarga.length,
                itemBuilder: (context, index) {
                  final anggota = anggotaKeluarga[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(
                        anggota['nama']!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${anggota['hubungan']} - ${anggota['nik']}',
                      ),
                      onTap: () {
                        // Aksi saat dipilih, bisa arahkan ke detail atau form
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
