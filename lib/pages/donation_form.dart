import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'donation_model.dart';
import '../auth/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';

//DONATION FORM WHEN YOU PRESS ADD DONATION BUTTON

class DonationForm extends StatefulWidget {
  const DonationForm({super.key});

  @override
  State<DonationForm> createState() => _DonationFormState();
}

class _DonationFormState extends State<DonationForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  static final numCheck = RegExp(r'^-?[0-9]+$');
  final TextEditingController donationTitle = TextEditingController();
  final TextEditingController donationDetails = TextEditingController();
  final TextEditingController donationQuantity = TextEditingController();
  final TextEditingController donationLocation = TextEditingController();
  final TextEditingController expirationDateController = TextEditingController();

  DateTime selectedExpirationDate = DateTime.now();

  Future<void> createDonation({
    required String donationTitle,
    required String donationDetails,
    required int donationQuantity,
    required String donationLocation,
    required Timestamp expirationDate,
  }) async {
    final docDonation =
        FirebaseFirestore.instance.collection('donations').doc();
    final donorInfo = FirebaseAuth.instance.currentUser!;

    final donationCrud = DonationModel(
        donationId: docDonation.id,
        donationTitle: donationTitle,
        donationDetails: donationDetails,
        donationQuantity: donationQuantity,
        donationLocation: donationLocation,
        donorEmail: donorInfo.email!,
        donorID: donorInfo.uid,
        expirationDate: expirationDate,
        donationStatus: 'Available',
        recipientId: 'Not Defined',
        recipientName: 'Not Defined',
        );
    final json = donationCrud.toJson();

    await docDonation.set(json);
  }

  @override
  void dispose() {
    donationTitle.dispose();
    donationDetails.dispose();
    donationQuantity.dispose();
    expirationDateController.dispose();
    donationLocation.dispose();
    return super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text(
        'Donation Form',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, color: Colors.black),
      ),
      content: Padding(
        padding: const EdgeInsets.all(0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: donationTitle,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Donation Title'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) =>
                    value!.isEmpty ? 'Title cannot be empty' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: donationDetails,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Donation Details',
                ),
                maxLines: 3,
                maxLength: 500,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) =>
                    value!.isEmpty ? 'Details cannot be empty' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: donationQuantity,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Donation Quantity'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value!.isEmpty
                    ? 'Quantity cannot be empty'
                    : (numCheck.hasMatch(value))
                        ? null
                        : 'Quantity should be numeric',
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: donationLocation,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Donation Location'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) =>
                    value!.isEmpty ? 'Location cannot be empty' : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: expirationDateController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Expiration Date',
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedExpirationDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2024));
                  if (pickedDate != null && pickedDate != selectedExpirationDate) {
                    // String formattedDate =
                    //     // DateFormat('yyyy-MM-dd').format(pickedDate);
                    setState(() {
                      expirationDateController.text = pickedDate.toString();
                      selectedExpirationDate = pickedDate;
                    }); 
                  }
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) =>
                    value!.isEmpty ? 'Date Not selected' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final isValid = _formKey.currentState!.validate();
            if (!isValid) return;
            try {
              createDonation(
                  donationTitle: donationTitle.text.trim(),
                  donationDetails: donationDetails.text.trim(),
                  donationQuantity: int.parse(donationQuantity.text.trim()),
                  donationLocation: donationLocation.text.trim(),
                  expirationDate: Timestamp.fromDate(selectedExpirationDate) 
                  );
              Utils.showSnackBarGreen('Successfully added Donation');
              Navigator.pop(context);
            } on FirebaseException catch (e) {
              Utils.showSnackBar(e.message);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
