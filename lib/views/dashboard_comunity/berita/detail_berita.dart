import 'package:flutter/material.dart';
import 'package:sibadeanmob_v2_fix/models/BeritaModel.dart';
import 'package:sibadeanmob_v2_fix/models/BeritaSuratModel.dart';
import '../../../theme/theme.dart';
import '/methods/api.dart';

class DetailBerita extends StatefulWidget {
  final int id;

  DetailBerita({required this.id});

  @override
  _DetailBeritaState createState() => _DetailBeritaState();
}

class _DetailBeritaState extends State<DetailBerita>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  Berita? dataModel;
  @override
  void initState() {
    super.initState();
    _getdetailberita();
  }

  Future<void> _getdetailberita() async {
    try {
      var response = await API().getdetailbrita(id: widget.id);
      if (response != null && response.statusCode == 200) {
        setState(() {
          dataModel = Berita.fromJson(response.data['data']['berita']);
          print("dataModel: $dataModel");
          isLoading = false;
        });
      } else {
        // error handling jika response null atau bukan 200
        print('Gagal memuat berita: ${response?.statusCode}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightColorScheme.primary,
        title: const Text(
          "List Berita & Peristiwa",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : dataModel == null
                ? Center(child: Text("Data tidak ditemukan"))
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/coba.png',
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                          SizedBox(height: 16),
                          Text(
                            dataModel!.judul,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            dataModel!.konten,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
