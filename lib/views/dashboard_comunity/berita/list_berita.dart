import 'package:flutter/material.dart';
import 'package:sibadeanmob_v2_fix/models/BeritaModel.dart';
import 'package:sibadeanmob_v2_fix/views/dashboard_comunity/berita/BeritaItem.dart';
import '../../../theme/theme.dart';
import '/methods/api.dart';

class ListBerita extends StatefulWidget {
  const ListBerita({super.key});

  @override
  _ListBeritaState createState() => _ListBeritaState();
}

class _ListBeritaState extends State<ListBerita> {
  bool isLoading = true;
  List<Berita> dataModel = [];
  String searchQuery = '';

  final List<String> judulBerita = [
    "Program Jumat Bersih di Kelurahan Badean Berjalan Sukses",
    "Kelurahan Badean Salurkan Bantuan Sosial untuk Warga Terdampak Banjir",
    "Lurah Baru Kelurahan Badean Resmi Dilantik",
    "Pelatihan Digital Marketing untuk UMKM Lokal",
    "Peringatan HUT RI ke-80 di Kelurahan Badean Meriah",
    "Warga Gotong Royong Bersihkan Saluran Air",
  ];

  @override
  void initState() {
    super.initState();
    fetchBerita();
  }

  Future<void> fetchBerita() async {
    try {
      var response = await API().getberita();
      if (response.statusCode == 200) {
        setState(() {
          dataModel = (response.data["data"]["berita"] as List)
              .map((item) => Berita.fromJson(item))
              .toList();
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredBerita = dataModel
        .where((berita) =>
            berita.judul.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title:
            Text("Berita", style: TextStyle(color: Colors.white, fontSize: 20)),
        backgroundColor: lightColorScheme.primary,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: fetchBerita,
                child: SingleChildScrollView(
                    child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        TextField(
                          decoration: InputDecoration(
                            hintText: "Cari berita...",
                            prefixIcon: const Icon(Icons.search),
                            filled: true, // Enables background color
                            fillColor: Colors
                                .grey.shade100, // Light gray background color
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(6), // Rounded corners
                              borderSide:
                                  BorderSide.none, // Remove border color
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 16.0),
                          ),
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Rekomendasi untukmu",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        filteredBerita.isEmpty
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 60),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.article_outlined,
                                        size: 80,
                                        color: Colors.grey.shade400,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        "Tidak ada berita",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : ListView.builder(
                                itemCount: filteredBerita.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return BeritaItem(
                                      berita: filteredBerita[index]);
                                },
                              ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                )),
              ),
      ),
    );
  }
}
