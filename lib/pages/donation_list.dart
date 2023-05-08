import 'package:flutter/material.dart';
import 'package:food_donation/pages/update_donation.dart';
import 'donation_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/utils.dart';

//READ DONATION AND CREATE DONATION LIST FUNCTIONS HERE

Future<String> getUserRole() async {
  final user = FirebaseAuth.instance.currentUser!;
  CollectionReference userRef = FirebaseFirestore.instance.collection('users');
  DocumentSnapshot documentSnapshot = await userRef.doc(user.uid).get();
  final userDoc = documentSnapshot.data() as Map<String, dynamic>;
  return userDoc['role'];
}

Future<String> getDonationInfo(String donationId, String info) async {
  CollectionReference donationRef =
      FirebaseFirestore.instance.collection('donations');
  DocumentSnapshot documentSnapshot = await donationRef.doc(donationId).get();
  final donationDoc = documentSnapshot.data() as Map<String, dynamic>;
  if (info == 'status') {
    return (donationDoc['status']);
  } else if (info == 'donorId') {
    return (donationDoc['donorID']);
  }
  return 'Undefined';
}

Future<void> requestDonation(String donationId) async {
  final user = FirebaseAuth.instance.currentUser!;
  final donationRef =
      FirebaseFirestore.instance.collection('donations').doc(donationId);
  await donationRef
      .update({
        'recipient': user.email,
        'recipientId': user.uid,
        'status': 'Requested'
      })
      .then((_) => Utils.showSnackBarGreen('Donation Requested'))
      .catchError((error) => Utils.showSnackBar(error));
}

Future<void> acceptDonation(String donationId) async {
  final donationRef =
      FirebaseFirestore.instance.collection('donations').doc(donationId);
  await donationRef
      .update({'status': 'Donated'})
      .then((_) => Utils.showSnackBarGreen('Donation Accepted'))
      .catchError((error) => Utils.showSnackBar(error));
}

Stream<List<DonationModel>> readDonations() => FirebaseFirestore.instance
    .collection('donations')
    .snapshots()
    .map((snapshot) => snapshot.docs
        .map((doc) => DonationModel.fromJson(doc.data()))
        .toList());

Widget buildDonationList(BuildContext context, DonationModel donation) =>
    Container(
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
                  Text(donation.donorEmail)
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
                  const Text('Expiration Date: '),
                  Text(donation.expirationDate.toDate().toString()),
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
                    onPressed: () async {
                      final user = FirebaseAuth.instance.currentUser!;
                      Future<String> donationStatus =
                          getDonationInfo(donation.donationId, 'status');
                      String status = await donationStatus;
                      Future<String> donorId =
                          getDonationInfo(donation.donationId, 'donorId');
                      String id = await donorId;
                      if ((user.uid == id) && status == 'Requested') {
                        acceptDonation(donation.donationId);
                      } else if (user.uid == id) {
                        Utils.showSnackBar('Cannot perform this action');
                      } else {
                        Utils.showSnackBar('Unauthorized User Access');
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    child: const Text('REQUEST'),
                    onPressed: () async {
                      Future<String> userRole = getUserRole();
                      String role = await userRole;
                      Future<String> donationStatus =
                          getDonationInfo(donation.donationId, 'status');
                      String status = await donationStatus;
                      if (role == 'recipient' && status == 'Available') {
                        requestDonation(donation.donationId);
                      } else if (role == 'recipient' && status == 'Requested') {
                        Utils.showSnackBar('Donation is already requested');
                      } else if (role == 'recipient' && status == 'Donated') {
                        Utils.showSnackBar('Donation is already completed');
                      } else {
                        Utils.showSnackBar('You cannot request donation');
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    child: const Text('EDIT'),
                    onPressed: () async {
                      final user = FirebaseAuth.instance.currentUser!;
                      Future<String> donorId =
                          getDonationInfo(donation.donationId, 'donorId');
                      String id = await donorId;
                      if (user.uid != id) {
                        Utils.showSnackBar('Unauthorized User Access');
                        return;
                      }
                      String donationId = donation.donationId;
                      String donationTitle = donation.donationTitle;
                      String donationDetails = donation.donationDetails;
                      int donationQuantity = donation.donationQuantity;
                      String donationLocation = donation.donationLocation;
                      String donorEmail = donation.donorEmail;
                      String donorID = donation.donorID;
                      Timestamp expirationDate = donation.expirationDate;
                      String recipientEmail = donation.recipientName;
                      String recipientId = donation.recipientId;
                      String donationStatus = donation.donationStatus;
                      showDialog(
                        context: context,
                        builder: ((context) => UpdateDonation(
                              donationId: donationId,
                              donationTitle: donationTitle,
                              donationDetails: donationDetails,
                              donationQuantity: donationQuantity,
                              donationLocation: donationLocation,
                              donorEmail: donorEmail,
                              donorId: donorID,
                              expirationDate: expirationDate,
                              recipientEmail: recipientEmail,
                              recipientId: recipientId,
                              donationStatus: donationStatus,
                            )),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    child: const Text('DELETE'),
                    onPressed: () async {
                      final user = FirebaseAuth.instance.currentUser!;
                      Future<String> donorId =
                          getDonationInfo(donation.donationId, 'donorId');
                      String id = await donorId;
                      if (user.uid != id) {
                        Utils.showSnackBar('Unauthorized User Access');
                        return;
                      }
                      
                      await FirebaseFirestore.instance
                          .collection('donations')
                          .doc(donation.donationId)
                          .delete();
                      Utils.showSnackBar('Donation was deleted');
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              )
            ],
          ),
        ),
      ),
    );
