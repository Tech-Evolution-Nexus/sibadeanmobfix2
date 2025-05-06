import 'package:flutter/material.dart';
import 'package:sibadeanmob_v2_fix/methods/api.dart';
import 'package:sibadeanmob_v2_fix/methods/auth.dart';
import 'package:sibadeanmob_v2_fix/models/MasyarakatModel.dart';

class DaftarAnggotaKeluargaView extends StatefulWidget {
  const DaftarAnggotaKeluargaView({Key? key}) : super(key: key);

  @override
  State<DaftarAnggotaKeluargaView> createState() => _DaftarAnggotaKeluargaViewState();
}

class _DaftarAnggotaKeluargaViewState extends State<DaftarAnggotaKeluargaView> {
  List<MasyarakatModel> anggotaKeluarga = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final user = await Auth.user();
      var response = await API().getAnggotaKeluarga(nokk: user["noKk"]);

      if (response.statusCode == 200) {
        setState(() {
          anggotaKeluarga = (response.data["data"] as List)
              .map((item) => MasyarakatModel.fromJson(item))
              .toList();
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : anggotaKeluarga.isEmpty
                ? const Center(child: Text("Tidak ada data anggota keluarga."))
                : Column(
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
                                  anggota.namaLengkap,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text('${anggota.statusKeluarga} - ${anggota.nik}'),
                                onTap: () {
                                  // Aksi saat dipilih
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
