import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DonationCRUD {
  final donorInfo = FirebaseAuth.instance.currentUser!;
  final String donationId;
  final String donationTitle;
  final String donationDetails;
  final int donationQuantity;
  final String donationLocation;
  final String recipientId = 'Not defined';
  final String recipientName = 'Not defined';
  final String donationStatus = 'Available';

  DonationCRUD({
    required this.donationId,
    required this.donationTitle,
    required this.donationDetails,
    required this.donationQuantity,
    required this.donationLocation,
    donationStatus,
  });

  Map<String, dynamic> toJson() => {
        'title': donationTitle,
        'donationId': donationId,
        'description': donationDetails,
        'quantity': donationQuantity,
        'location': donationLocation,
        'donor': donorInfo.email!,
        'donorID': donorInfo.uid,
        'recipient': recipientName,
        'recipientId': recipientId,
        'timeStamp': FieldValue.serverTimestamp(),
        'status': donationStatus
      };

  static DonationCRUD fromJson(Map<String, dynamic> json) => DonationCRUD(
        donationId: json['donationId'],
        donationTitle: json['title'],
        donationDetails: json['description'],
        donationQuantity: json['quantity'],
        donationLocation: json['location'],
        donationStatus : json['status'],
      );
}
