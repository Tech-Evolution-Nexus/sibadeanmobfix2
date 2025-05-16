import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PDFViewerPage extends StatelessWidget {
  final String url;
  final String title;

  PDFViewerPage({required this.url, required this.title});

  Future<void> downloadFile(BuildContext context) async {
    try {
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Izin penyimpanan ditolak")),
        );
        return;
      }

      String fileName = url.split('/').last;

      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (!(await directory.exists())) {
        await directory.create(recursive: true);
      }

      String savePath = '${directory.path}/$fileName';

      await Dio().download(url, savePath);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Berhasil diunduh ke: $savePath")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal mengunduh file: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('URL PDF: $url'); // Debug

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () => downloadFile(context),
          ),
        ],
      ),
      body: SfPdfViewer.network(
        url,
        onDocumentLoadFailed: (details) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal memuat PDF: ${details.description}')),
          );
        },
      ),
    );
  }
}
