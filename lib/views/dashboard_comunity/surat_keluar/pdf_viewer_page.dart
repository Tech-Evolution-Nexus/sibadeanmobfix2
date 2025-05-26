import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerPage extends StatefulWidget {
  final String url;
  final String title;

  const PDFViewerPage({Key? key, required this.url, required this.title})
      : super(key: key);

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
      final filePath = '${dir.path}/$fileName';

      final file = File(filePath);

      if (await file.exists()) {
        setState(() {
          localFilePath = filePath;
          isLoading = false;
        });
        return;
      }

      await Dio().download(widget.url, filePath);

      setState(() {
        localFilePath = filePath;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Gagal mengunduh PDF: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
            title: Text('Loading ${widget.title}',
                style: TextStyle(color: Colors.white, fontSize: 18))),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
            title: Text('Error',
                style: TextStyle(color: Colors.white, fontSize: 18))),
        body: Center(child: Text(errorMessage!)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.title,
            style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
      body: SfPdfViewer.file(File(localFilePath!)),
    );
  }
}
