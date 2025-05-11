import 'package:flutter/material.dart';

class DetailSurat extends StatelessWidget {
  final int id;

  DetailSurat({required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Surat')),
      body: Center(
        child: Text('Detail Surat with ID: $id'),
      ),
    );
  }
}
