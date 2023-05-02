import 'package:cloud_firestore/cloud_firestore.dart';

//DONATION CLASS MODEL

class DonationModel {
  final String donationId;
  final String donationTitle;
  final String donationDetails;
  final int donationQuantity;
  final String donationLocation;
  final String recipientId = 'Not defined';
  final String recipientName = 'Not defined';
  final String donationStatus = 'Available';
  final String donorEmail;
  final String donorID;
  final Timestamp expirationDate;

  DonationModel({
    required this.donationId,
    required this.donationTitle,
    required this.donationDetails,
    required this.donationQuantity,
    required this.donationLocation,
    required this.donorEmail,
    required this.donorID,
    required this.expirationDate,
    donationStatus,
  });

  Map<String, dynamic> toJson() => {
        'title': donationTitle,
        'donationId': donationId,
        'description': donationDetails,
        'quantity': donationQuantity,
        'location': donationLocation,
        'donor': donorEmail,
        'donorID': donorID,
        'recipient': recipientName,
        'recipientId': recipientId,
        'timeStamp': FieldValue.serverTimestamp(),
        'expirationDate': expirationDate,
        'status': donationStatus
      };

  static DonationModel fromJson(Map<String, dynamic> json) => DonationModel(
        donationId: json['donationId'],
        donationTitle: json['title'],
        donationDetails: json['description'],
        donationQuantity: json['quantity'],
        donationLocation: json['location'],
        donorEmail: json['donor'],
        donorID: json['donorID'],
        donationStatus : json['status'],
        expirationDate: json['expirationDate']
      );
}
