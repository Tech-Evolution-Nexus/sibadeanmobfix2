import 'package:flutter/material.dart';
import 'package:sibadeanmob_v2_fix/models/BeritaModel.dart';
import '../../../theme/theme.dart';
import '/methods/api.dart';

class ListBerita extends StatefulWidget {
  const ListBerita({super.key});

  @override
  _ListBeritaState createState() => _ListBeritaState();
}

class _ListBeritaState extends State<ListBerita>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = true;
  Berita? dataModel;
  @override
  void initState() {
    super.initState();
    fetchBerita();
  }


  Future<void> fetchBerita() async {
    try {
      var response = await API().getdatadashboard();
      if (response.statusCode == 200) {
        setState(() {
          dataModel = Berita.fromJson(response.data['data']);
          isLoading = false;
        });
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
        title: const Text('List Berita & Peristiwa'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar utama
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: Image.asset(
                      'assets/images/coba.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Kelurahan Badean Gelar Pelatihan UMKM untuk Warga",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "16 April 2025",
                  style: TextStyle(color: Colors.grey),
                ),
                const Divider(height: 24),
                // List berita lainnya
                ListView.builder(
                  itemCount: 6,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final List<String> judulBerita = [
                      "Program Jumat Bersih di Kelurahan Badean Berjalan Sukses",
                      "Kelurahan Badean Salurkan Bantuan Sosial untuk Warga Terdampak Banjir",
                      "Lurah Baru Kelurahan Badean Resmi Dilantik",
                      "Lurah Baru Kelurahan Badean Resmi Dilantik",
                      "Lurah Baru Kelurahan Badean Resmi Dilantik",
                      "Lurah Baru Kelurahan Badean Resmi Dilantik",
                    ];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.asset(
                            'assets/images/coba.png',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(judulBerita[index]),
                        subtitle: const Text("16 April 2025"),
                        onTap: () {
                          // Tambahkan navigasi ke detail berita jika diinginkan
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
