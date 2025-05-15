import 'package:flutter/material.dart';
import 'ApiService.dart';

class SuratKeluarPage extends StatefulWidget {
  @override
  _SuratKeluarPageState createState() => _SuratKeluarPageState();
}

class _SuratKeluarPageState extends State<SuratKeluarPage> {
  final ApiService apiService = ApiService();
  late Future<List<dynamic>> suratKeluarFuture;

  @override
  void initState() {
    super.initState();
    suratKeluarFuture = apiService.fetchSuratKeluar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Surat Keluar')),
      body: FutureBuilder<List<dynamic>>(
        future: suratKeluarFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));

          if (!snapshot.hasData || snapshot.data!.isEmpty)
            return Center(child: Text('Tidak ada surat keluar'));

          final suratList = snapshot.data!;

          return ListView.builder(
            itemCount: suratList.length,
            itemBuilder: (context, index) {
              final surat = suratList[index];
              return ListTile(
                title: Text(surat['title']),
                subtitle: Text('Exp: ${surat['exp_date']}'),
                trailing: Icon(Icons.picture_as_pdf),
                onTap: () {
                  // bisa untuk buka detail surat atau file pdf
                },
              );
            },
          );
        },
      ),
    );
  }
}
