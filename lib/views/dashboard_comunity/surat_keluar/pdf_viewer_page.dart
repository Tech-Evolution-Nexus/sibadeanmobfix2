import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerPage extends StatelessWidget {
  final String url;
  final String title;

  PDFViewerPage({required this.url, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {
              // Implementasi download bisa kamu tambahkan di sini
            },
          ),
        ],
      ),
      body: SfPdfViewer.network(url),
    );
  }
}
