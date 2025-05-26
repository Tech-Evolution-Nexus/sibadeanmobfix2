import 'package:flutter/material.dart';
import 'package:sibadeanmob_v2_fix/models/Pengaturan.dart';

class TentangPage extends StatefulWidget {
  const TentangPage({super.key});

  @override
  State<TentangPage> createState() => _TentangPageState();
}

class _TentangPageState extends State<TentangPage> {
  Pengaturan? pengaturan;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchPengaturan();
  }

  Future<void> fetchPengaturan() async {
    var res = await Pengaturan.getPengaturan();
    setState(() {
      pengaturan = res;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // pengaturan.
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Tentang",
            style: TextStyle(color: Colors.black, fontSize: 18)),
        backgroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.network(
                    pengaturan?.logo ?? "", // Ganti dengan logo aplikasi kamu
                    width: 100,
                    height: 100,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "E-Surat Badean",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    pengaturan?.descApk ?? "",
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text("2.0.0", style: TextStyle(color: Colors.grey)),
                )
              ],
            ),
    );
  }
}
