import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

Future<void> downloadAndOpenFile(
    BuildContext context, String url, String fileName) async {
  try {
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/$fileName';

    final response = await Dio().download(url, filePath);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Berhasil mengunduh $fileName')),
      );
      await OpenFile.open(filePath);
    } else {
      throw Exception('Gagal mengunduh file');
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Gagal mengunduh file: $e')),
    );
  }
}
