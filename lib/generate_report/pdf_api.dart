import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name;
  final int age;

  const User({required this.name, required this.age});
}

class PdfApi {
  static Future<File> generateTable() async {
    
    CollectionReference donationRef = FirebaseFirestore.instance.collection('donations');
    QuerySnapshot querySnapshot = await donationRef.get();
    final donationData = querySnapshot.docs.map((doc) => doc.data() as Map<String,dynamic>).toList();
    
    final pdf = Document();
    final headers = ['Donor','Title', 'Description', 'Quantity','Location','Status'];
    

    final data = donationData.map((donation) => [donation['donor'], donation['title'],donation['description'], donation['quantity'],donation['location'], donation['status']]).toList();
    // final data = users.map((user) => [user.name, user.age]).toList();
    // final font = await rootBundle.load("assets/open_sans.ttf");
    // final ttf = Font.ttf(font);



    pdf.addPage(Page(
        build: (context) => Table.fromTextArray(
              headers: headers,
              data: data,    
            )
            
            ));

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
