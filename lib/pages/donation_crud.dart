class DonationCRUD{
  final String donationId;
  final String donationTitle;
  final String donationDetails;
  final num donationQuantity;
  final String donationLocation;
  final String donorName = 'Not defined';
  final String recipientName = 'Not defined';

  DonationCRUD({
    required this.donationId,
    required this.donationTitle,
    required this.donationDetails,
    required this.donationQuantity,
    required this.donationLocation,
  });

  

}