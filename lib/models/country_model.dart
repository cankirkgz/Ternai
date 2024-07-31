import 'package:cloud_firestore/cloud_firestore.dart';

class Country {
  String id;
  String name;
  String currency;
  String timezone;
  String countryImageUrl;

  Country({
    required this.id,
    required this.name,
    required this.currency,
    required this.timezone,
    required this.countryImageUrl,
  });

  factory Country.fromMap(Map<String, dynamic> data, String documentId) {
    return Country(
      id: data['countryId'] ?? documentId,
      name: data['name'] ?? '',
      currency: data['currency'] ?? '',
      timezone: data['timezone'] ?? '',
      countryImageUrl: data['countryImageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'countryId': id,
      'name': name,
      'currency': currency,
      'timezone': timezone,
      'countryImageUrl': countryImageUrl,
    };
  }
}

class CountryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Country?> getCountryByName(String countryName) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('countries')
          .where('name', isEqualTo: countryName)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final countryData = Country.fromMap(
          querySnapshot.docs.first.data() as Map<String, dynamic>,
          querySnapshot.docs.first.id,
        );
        print("Country found currency: ${countryData.currency}");
        print("Country found image: ${countryData.countryImageUrl}");
        return countryData;
      } else {
        print('Country not found');
        return null;
      }
    } catch (e) {
      print('Country fetch error: $e');
      return null;
    }
  }
}
