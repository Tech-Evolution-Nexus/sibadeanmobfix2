import 'package:flutter/material.dart';
import 'package:sibadeanmob_v2_fix/methods/api.dart';
import 'package:sibadeanmob_v2_fix/methods/auth.dart';
import 'package:sibadeanmob_v2_fix/models/MasyarakatModel.dart';
import 'package:sibadeanmob_v2_fix/theme/theme.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/pengajuan_surat/pengajuan_surat.dart';

class DaftarAnggotaKeluargaView extends StatefulWidget {
  final int idsurat;
  final String namasurat;

  const DaftarAnggotaKeluargaView(
      {Key? key, required this.idsurat, required this.namasurat})
      : super(key: key);

  @override
  State<DaftarAnggotaKeluargaView> createState() =>
      _DaftarAnggotaKeluargaViewState();
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
      final nokk = user['noKK']?.toString();

      print("NoKK dari user: $nokk");

      if (nokk == null || nokk.isEmpty) {
        setState(() => isLoading = false);
        return;
      }

      var response = await API().getAnggotaKeluarga(nokk: nokk);

      if (response.statusCode == 200 &&
          response.data != null &&
          response.data["data"] != null) {
        final List<dynamic> dataJson = response.data["data"];

        setState(() {
          anggotaKeluarga =
              dataJson.map((item) => MasyarakatModel.fromJson(item)).toList();
          isLoading = false;
        });
      } else {
        print("Gagal fetch data: statusCode ${response.statusCode}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error saat fetch data: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Daftar Anggota Keluarga',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.white,
          ),
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
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PengajuanSuratPage(
                                        idsurat: widget.idsurat,
                                        namaSurat: widget.namasurat,
                                        nik: anggota.nik),
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 4),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                        width: 1, color: Colors.grey.shade200)),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        anggota.namaLengkap,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        anggota.nik,
                                        style: TextStyle(
                                            color: Colors.grey.shade700),
                                      ),
                                    ],
                                  ),
                                ),
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
