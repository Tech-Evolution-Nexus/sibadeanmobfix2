import 'package:flutter/material.dart';
import 'package:sibadeanmob_v2_fix/models/BeritaModel.dart';
import 'package:sibadeanmob_v2_fix/models/BeritaSuratModel.dart';
import '../../../theme/theme.dart';
import '/methods/api.dart';
import 'package:flutter_html/flutter_html.dart';

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
                              child: Image.network(
                                dataModel!.gambar ?? '', // URL gambar dari data
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  // Jika gagal load gambar, tampilkan gambar alternatif online
                                  return Image.network(
                                    'https://dummyimage.com/80x80/f2f2f2/555555&text=No+Image',
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Html(
                            data: dataModel!.konten,
                            style: {
                              "body": Style(
                                fontSize: FontSize(14),
                                color: Colors.black87,
                              ),
                              "p": Style(
                                fontSize: FontSize(14),
                                margin: Margins.zero,
                              ),
                              "b": Style(fontWeight: FontWeight.bold),
                              "strong": Style(fontWeight: FontWeight.bold),
                              "i": Style(fontStyle: FontStyle.italic),
                              "em": Style(fontStyle: FontStyle.italic),
                              "u": Style(
                                  textDecoration: TextDecoration.underline),
                              "a": Style(
                                color: Colors.blue,
                                textDecoration: TextDecoration.underline,
                              ),
                              "h1": Style(
                                  fontSize: FontSize(24),
                                  fontWeight: FontWeight.bold),
                              "h2": Style(
                                  fontSize: FontSize(22),
                                  fontWeight: FontWeight.bold),
                              "h3": Style(
                                  fontSize: FontSize(20),
                                  fontWeight: FontWeight.bold),
                              "h4": Style(
                                  fontSize: FontSize(18),
                                  fontWeight: FontWeight.bold),
                              "h5": Style(
                                  fontSize: FontSize(16),
                                  fontWeight: FontWeight.bold),
                              "h6": Style(
                                  fontSize: FontSize(14),
                                  fontWeight: FontWeight.bold),
                              "ul": Style(
                                  margin: Margins.zero,
                                  padding: HtmlPaddings.only(left: 20)),
                              "ol": Style(
                                  margin: Margins.zero,
                                  padding: HtmlPaddings.only(left: 20)),
                              "li": Style(margin: Margins.only(bottom: 6)),
                              "img": Style(margin: Margins.only(bottom: 12)),
                              "table": Style(
                                border: Border.all(color: Colors.grey),
                              ),
                              "th": Style(
                                padding: HtmlPaddings.all(6),
                                backgroundColor: Colors.grey.shade200,
                              ),
                              "td": Style(
                                padding: HtmlPaddings.all(6),
                              ),
                            },
                            onLinkTap: (url, attributes, element) {
                              print("Diklik: $url");
                              // Bisa pakai launchUrl atau Navigator jika mau buka sesuatu
                            },
                          )
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
