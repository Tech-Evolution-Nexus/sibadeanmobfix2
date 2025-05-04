import 'package:flutter/material.dart';
import '../../../theme/theme.dart';

class ListBerita extends StatefulWidget {
  @override
  _ListBeritaState createState() => _ListBeritaState();
}

class _ListBeritaState extends State<ListBerita>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar dibatasi tingginya agar tidak menyebabkan overflow
              SizedBox(
                width: double.infinity,
                height: 200,
                child: Image.asset(
                  'assets/images/coba.png',
                  fit: BoxFit.cover,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Judul Berita",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Konten Berita",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
