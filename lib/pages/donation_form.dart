import 'package:flutter/material.dart';

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

  @override
  void dispose() {
    donationTitle.dispose();
    donationDetails.dispose();
    donationQuantity.dispose();
    donationDetails.dispose();
    super.dispose();
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
          onPressed: () => Navigator.pop(context),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
