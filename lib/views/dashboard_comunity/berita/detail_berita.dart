import 'package:flutter/material.dart';
import 'package:sibadeanmob_v2_fix/models/BeritaModel.dart';
import 'package:sibadeanmob_v2_fix/models/BeritaSuratModel.dart';
import '../../../theme/theme.dart';
import '/methods/api.dart';

class DetailBerita extends StatefulWidget {
  final int id;

  const DetailBerita({super.key, required this.id});

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
          isLoading = false;
        });
      } else {
        // error handling jika response null atau bukan 200
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // title: const Text('Berita'),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context),
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
                          Text(
                            dataModel!.createdAt,
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            dataModel!.judul,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(6), // Sesuaikan radius
                              child: Image.asset(
                                'assets/images/berita-sample.jpg',
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            dataModel!.konten,
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
