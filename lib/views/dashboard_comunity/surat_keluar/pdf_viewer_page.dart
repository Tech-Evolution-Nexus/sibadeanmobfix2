import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerPage extends StatefulWidget {
  final String url;
  final String title;

  const PDFViewerPage({Key? key, required this.url, required this.title}) : super(key: key);

  @override
  State<PDFViewerPage> createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  String? localFilePath;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    downloadPdf();
  }

  Future<void> downloadPdf() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final fileName = widget.url.split('/').last.split('?').first;
      final filePath = "${dir.path}/$fileName";

      final file = File(filePath);

      if (await file.exists()) {
        await file.delete();
      }

      final response = await Dio().download(widget.url, filePath);

      if (response.statusCode == 200) {
        setState(() {
          localFilePath = filePath;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Gagal mengunduh file PDF (Status: ${response.statusCode})";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Terjadi kesalahan: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text("Memuat ${widget.title}...")),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: Text("Error")),
        body: Center(child: Text(errorMessage!)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SfPdfViewer.file(File(localFilePath!)),
    );
  }
}
