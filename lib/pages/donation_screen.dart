import 'package:flutter/material.dart';
import 'package:food_donation/auth/utils.dart';
import 'package:food_donation/pages/donation_form.dart';
import 'donation_model.dart';
import 'donation_list.dart';
import '../generate_report/pdf_api.dart';
import '../generate_report/pdf_view.dart';

//MAIN DONATION SCREEN
//DONATION LIST AND DONATION ADD BUTTON HERE

class DonationPage extends StatefulWidget {
  const DonationPage({super.key});

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  //readDonation() and buildDonationList() were previously here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<List<DonationModel>>(
          stream: readDonations(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Some thing went wrong! ${snapshot.error}');
            } else if (snapshot.hasData) {
              final donationList = snapshot.data!;
              return ListView(
                children: donationList.map((donation) {
                  return buildDonationList(context, donation);
                }).toList(),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              backgroundColor: Colors.blue,
              onPressed: () async {
                Future<String> userRole = getUserRole();
                String role = await userRole;
                if (role != 'admin'){
                  Utils.showSnackBar('Admin Privilege Only');
                  return;
                }
                final pdfFile = await PdfApi.generateTable();
                showDialog(
                  context: context,
                  builder: ((context) => PdfViewer(
                        file: pdfFile,
                      )),
                );
              },
              heroTag: null,
              child: const Icon(Icons.save),
            ),
            const SizedBox(
              height: 15,
            ),
            FloatingActionButton(
              backgroundColor: Colors.blue,
              onPressed: () async {
                Future<String> userRole = getUserRole();
                String role = await userRole;
                if (role == 'recipient'){
                  Utils.showSnackBar('Recipient Cannot Donate');
                  return;
                }
                showDialog(
                  context: context,
                  builder: ((context) => const DonationForm()),
                );
              },
              heroTag: null,
              child: const Icon(Icons.add),
            ),
          ],
        ));
  }
}


/*
FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          showDialog(
            context: context,
            builder: ((context) => const DonationForm()),
          );
        },
        child: const Icon(Icons.add),
      ),
 */