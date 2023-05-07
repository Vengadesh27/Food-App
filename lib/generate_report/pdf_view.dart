import 'package:flutter/material.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'dart:io';

class PdfViewer extends StatelessWidget {
  final File file;
  const PdfViewer({required this.file, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Report Generation')),
        ),
        body: PdfView(path: file.path));
  }
}
