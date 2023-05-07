import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'dart:io';

class User {
  final String name;
  final int age;

  const User({required this.name, required this.age});
}

class PdfApi {
  static Future<File> generateTable() async {
    final pdf = Document();
    final headers = ['Name', 'Age'];
    final users = [
      const User(name: 'James', age: 19),
      const User(name: 'Sarah', age: 21),
      const User(name: 'Emma', age: 28)
    ];

    final data = users.map((user) => [user.name, user.age]).toList();
    final font = await rootBundle.load("assets/open_sans.ttf");
    final ttf = Font.ttf(font);

    pdf.addPage(Page(
        build: (context) => Table.fromTextArray(
              headers: headers,
              data: data,
              
            )));

    return await saveDocument(name: 'my_example.pdf', pdf: pdf);
  }

  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);
    return file;
  }
}
