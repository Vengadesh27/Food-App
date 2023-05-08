import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth/utils.dart';
import 'donation_model.dart';

class UpdateDonation extends StatefulWidget {
  final String donationId,
      donationTitle,
      donationDetails,
      donationLocation,
      donorEmail,
      donorId,
      recipientId,
      recipientEmail,
      donationStatus;
  final int donationQuantity;
  final Timestamp expirationDate;
  const UpdateDonation(
      {required this.donationId,
      required this.donationTitle,
      required this.donationDetails,
      required this.donationLocation,
      required this.donorEmail,
      required this.donorId,
      required this.donationQuantity,
      required this.expirationDate,
      required this.recipientEmail,
      required this.recipientId,
      required this.donationStatus,
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
  final TextEditingController expirationDateController =
      TextEditingController();
  late DateTime selectedExpirationDate;

  Future<void> updateDonation(
      {required String donationId,
      required String donationTitle,
      required String donationDetails,
      required String donationLocation,
      required String donorEmail,
      required String donorId,
      required int donationQuantity,
      required Timestamp expirationDate,
      required String recipientId,
      required String recipientEmail,
      required String donationStatus,
      }) async {
    final docDonation =
        FirebaseFirestore.instance.collection('donations').doc(donationId);

    final donationCrud = DonationModel(
      donationId: donationId,
      donationTitle: donationTitle,
      donationDetails: donationDetails,
      donationQuantity: donationQuantity,
      donationLocation: donationLocation,
      donorEmail: donorEmail,
      donorID: donorId,
      expirationDate: expirationDate,
      recipientId: recipientId,
      recipientName: recipientEmail,
      donationStatus: donationStatus
    );
    final json = donationCrud.toJson();
    await docDonation
        .update(json)
        .then((_) => Utils.showSnackBarGreen('Donation was updated'))
        .catchError((error) => Utils.showSnackBar('$error occured'));
  }

  @override
  void initState() {
    donationTitle.text = widget.donationTitle;
    donationDetails.text = widget.donationDetails;
    donationQuantity.text = widget.donationQuantity.toString();
    donationLocation.text = widget.donationLocation;
    expirationDateController.text = widget.expirationDate.toDate().toString();
    selectedExpirationDate = widget.expirationDate.toDate();
    return super.initState();
  }

  @override
  void dispose() {
    donationTitle.dispose();
    donationDetails.dispose();
    donationQuantity.dispose();
    donationLocation.dispose();
    expirationDateController.dispose();
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
                  if (pickedDate != null) {
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
              updateDonation(
                donationId: widget.donationId,
                donationTitle: donationTitle.text.trim(),
                donationDetails: donationDetails.text.trim(),
                donationQuantity: int.parse(donationQuantity.text.trim()),
                donationLocation: donationLocation.text.trim(),
                donorEmail: widget.donorEmail,
                donorId: widget.donorId,
                expirationDate: Timestamp.fromDate(selectedExpirationDate),
                recipientEmail: widget.recipientEmail,
                recipientId:  widget.recipientId,
                donationStatus: widget.donationStatus,
              );
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
