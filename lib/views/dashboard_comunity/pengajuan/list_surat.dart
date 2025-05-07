import 'package:flutter/material.dart';
import 'package:sibadeanmob_v2_fix/models/BeritaModel.dart';
import 'package:sibadeanmob_v2_fix/models/BeritaSuratModel.dart';
import 'package:sibadeanmob_v2_fix/models/SuratModel.dart';
import 'pengajuan_surat.dart';
import '../../../theme/theme.dart';
import '/methods/api.dart';

class ListSurat extends StatefulWidget {
  @override
  ListSuratState createState() => ListSuratState();
}

class ListSuratState extends State<ListSurat> {
  void initState() {
    super.initState();
    fetchSurat();
  }

  List<Surat>? dataModel;
  bool isLoading = true;
  Future<void> fetchSurat() async {
    try {
      var response = await API().getdatasurat();
      if (response.statusCode == 200) {
        setState(() {
          dataModel = (response.data['data']['surat'] as List)
              .map((item) => Surat.fromJson(item))
              .toList();
          print(response.data['data']['surat']);
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
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;
    final isSmall = width < 360;
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Surat'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: height * 0.015),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            dataModel == null
                ? const Center(child: CircularProgressIndicator())
                : Wrap(
                    alignment: WrapAlignment.start,
                    spacing: width * 0.05,
                    runSpacing: height * 0.02,
                    children: [
                      ...dataModel!.map(
                        (item) =>
                            _suratButton(context, item, Colors.blue, width),
                      ),
                    ],
                  ),
            SizedBox(height: height * 0.02),
          ],
        ),
      ),
    );
  }
}

Widget _statusItem(String title, String count, bool isSmall) {
  return Column(
    children: [
      Text(
        count,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: isSmall ? 16 : 18,
          color: lightColorScheme.primary,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        title,
        style: TextStyle(
          color: Colors.black54,
          fontSize: isSmall ? 11 : 12,
        ),
        textAlign: TextAlign.center,
      ),
    ],
  );
}

Widget _suratButton(
    BuildContext context, Surat item, Color color, double width) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PengajuanSuratPage(
                idsurat: item.id, namaSurat: item.nama_surat)),
      );
    },
    child: Column(
      children: [
        CircleAvatar(
          radius: width * 0.08,
          backgroundColor: color,
          child: const Icon(Icons.mail_rounded, color: Colors.white),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: width * 0.2,
          child: Text(
            item.nama_surat,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    ),
  );
}

Widget _lihatSemuaButton(BuildContext context, double width) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ListSurat()));
    },
    child: Column(
      children: [
        CircleAvatar(
          radius: width * 0.06,
          backgroundColor: Colors.grey.shade300,
          child: const Icon(Icons.apps_rounded, color: Colors.black),
        ),
        const SizedBox(height: 8),
        const Text("Lihat Semua", style: TextStyle(fontSize: 12)),
      ],
    ),
  );
}
