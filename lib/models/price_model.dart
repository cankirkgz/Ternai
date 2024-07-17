import 'package:cloud_firestore/cloud_firestore.dart';

class Price {
  String id;
  String countryId;
  String productServiceId;
  String productServiceName; // yeni eklenen alan
  double price;
  String currency;
  DateTime lastUpdated;

  Price({
    required this.id,
    required this.countryId,
    required this.productServiceId,
    required this.productServiceName, // yeni eklenen alan
    required this.price,
    required this.currency,
    required this.lastUpdated,
  });

  factory Price.fromMap(Map<String, dynamic> data, String documentId) {
    return Price(
      id: documentId,
      countryId: data['country_id'],
      productServiceId: data['product_service_id'],
      productServiceName: data['product_service_name'], // yeni eklenen alan
      price: data['price'],
      currency: data['currency'],
      lastUpdated: (data['last_updated'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'country_id': countryId,
      'product_service_id': productServiceId,
      'product_service_name': productServiceName, // yeni eklenen alan
      'price': price,
      'currency': currency,
      'last_updated': lastUpdated,
    };
  }
}
