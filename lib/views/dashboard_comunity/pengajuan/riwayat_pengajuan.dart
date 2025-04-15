import 'package:flutter/material.dart';
import '../../../theme/theme.dart';

class PengajuanPage extends StatefulWidget {
  @override
  _PengajuanPageState createState() => _PengajuanPageState();
}

class _PengajuanPageState extends State<PengajuanPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightColorScheme.primary,
        title: Text("Pengajuan Surat", style: TextStyle(color: Colors.white)),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: "Diajukan"),
            Tab(text: "Diterima"),
            Tab(text: "ACC"),
            Tab(text: "Download"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          statusSurat("Surat yang diajukan"),
          statusSurat("Surat yang diterima"),
          statusSurat("Surat yang di ACC"),
          statusSurat("Surat yang bisa di-download"),
        ],
      ),
    );
  }

  Widget statusSurat(String status) {
    return Center(
      child: Text(status, style: TextStyle(fontSize: 18)),
    );
  }
}
