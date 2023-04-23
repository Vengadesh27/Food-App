import 'package:flutter/material.dart';
import 'package:food_donation/pages/donation_form.dart';

class DonationPage extends StatefulWidget {
  const DonationPage({super.key});

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  State<DonationPage> createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Add Donations'),
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
