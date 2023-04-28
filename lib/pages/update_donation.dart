import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdateDonation extends StatefulWidget {
  final String donationId,
      donationTitle,
      donationDetails,
      donationLocation,
      donorEmail,
      donorId;
  final int donationQuantity;
  const UpdateDonation(
      {required this.donationId,
      required this.donationTitle,
      required this.donationDetails,
      required this.donationLocation,
      required this.donorEmail,
      required this.donorId,
      required this.donationQuantity,
      super.key});

  @override
  State<UpdateDonation> createState() => _UpdateDonationState();
}

class _UpdateDonationState extends State<UpdateDonation> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  static final numCheck = RegExp(r'^-?[0-9]+$');
  final TextEditingController donationTitle = TextEditingController();
  final TextEditingController donationDetails = TextEditingController();
  final TextEditingController donationQuantity = TextEditingController();
  final TextEditingController donationLocation = TextEditingController();


  Future<void> updateValues() async {


  }
  @override
  void initState() {
    donationTitle.text = widget.donationTitle;
    donationDetails.text = widget.donationDetails;
    donationQuantity.text = widget.donationQuantity.toString();
    donationLocation.text = widget.donationLocation;
    return super.initState();
  }

  @override
  void dispose() {
    donationTitle.dispose();
    donationDetails.dispose();
    donationQuantity.dispose();
    donationDetails.dispose();
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
              //TODO: Add updatevalue() function here
              Navigator.pop(context);
            } on FirebaseException catch (e) {
              Utils.showSnackBar(e.message);
            }
          },
          child: const Text('Update'),
        ),
      ],
    );
  }
}
