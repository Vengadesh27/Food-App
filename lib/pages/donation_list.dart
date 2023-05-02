import 'package:flutter/material.dart';
import 'package:food_donation/pages/update_donation.dart';
import 'donation_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../auth/utils.dart';

//READ DONATION AND CREATE DONATION LIST FUNCTIONS HERE

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
                    onPressed: () {
                      String donationId = donation.donationId;
                      String donationTitle = donation.donationTitle;
                      String donationDetails = donation.donationDetails;
                      int donationQuantity = donation.donationQuantity;
                      String donationLocation = donation.donationLocation;
                      String donorEmail = donation.donorEmail;
                      String donorID = donation.donorID;
                      Timestamp expirationDate = donation.expirationDate;
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
                            )),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    child: const Text('DELETE'),
                    onPressed: () async {
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
