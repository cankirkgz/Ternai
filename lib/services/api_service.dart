import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/country_model.dart';
import '../models/category_model.dart';
import '../models/product_service_model.dart';
import '../models/price_model.dart';

class ApiService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Tüm ülkeleri getiren fonksiyon
  Future<List<Country>> getCountries() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('countries').get();
      return snapshot.docs
          .map((doc) =>
              Country.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print("Error getting countries: $e");
      rethrow;
    }
  }

  // Tüm kategorileri getiren fonksiyon
  Future<List<Category>> getCategories() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('categories').get();
      return snapshot.docs
          .map((doc) =>
              Category.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print("Error getting categories: $e");
      rethrow;
    }
  }

  // Ürün veya hizmetleri getiren fonksiyon
  Future<List<ProductModel>> getProductServices() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection('products_services').get();
      return snapshot.docs
          .map((doc) =>
              ProductModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print("Error getting product services: $e");
      rethrow;
    }
  }

  Future<List<Price>> getPrices(
      String countryId, String categoryId, String? productServiceId) async {
    try {
      Query query = _firestore
          .collection('prices')
          .where('country_id', isEqualTo: countryId);

      if (productServiceId != null) {
        query = query.where('product_service_id', isEqualTo: productServiceId);
      }

      QuerySnapshot snapshot = await query.get();

      return snapshot.docs
          .map((doc) =>
              Price.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
