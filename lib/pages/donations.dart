import 'package:flutter/material.dart';
import 'package:food_donation/pages/donation_form.dart';
import '../pages/donation_crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonationPage extends StatefulWidget {
  const DonationPage({super.key});

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  Stream<List<DonationCRUD>> readDonations() => FirebaseFirestore.instance
      .collection('donations')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => DonationCRUD.fromJson(doc.data()))
          .toList());

  // Future<void> _deleteProduct(String productId) async {
  //   await _productss.doc(productId).delete();

  // final docDonation =
  //       FirebaseFirestore.instance.collection('donations');

  Widget buildDonationList(DonationCRUD donation) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Card(
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Text(
                      donation.donationTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Text('Details: '),
                    Text(
                      donation.donationDetails,
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Text('Quantity: '),
                    Text(donation.donationQuantity.toString())
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Text('Location: '),
                    Text(donation.donationLocation)
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Text('Donated By: '),
                    Text(donation.donorInfo.email!)
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Text('Recipient: '),
                    Text(donation.recipientName)
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Text('Status: '),
                    Text(donation.donationStatus),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      child: const Text('ACCEPT'),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      child: const Text('REQUEST'),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      child: const Text('EDIT'),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      child: const Text('DELETE'),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 8),
                  ],
                )
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<DonationCRUD>>(
        stream: readDonations(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Some thing went wrong! ${snapshot.error}');
          } else if (snapshot.hasData) {
            final donationList = snapshot.data!;
            return ListView(
              children: donationList.map(buildDonationList).toList(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          showDialog(
              context: context, builder: ((context) => const DonationForm()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
