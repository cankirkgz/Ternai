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
      throw e;
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
      throw e;
    }
  }

  // Ürün veya hizmetleri getiren fonksiyon
  Future<List<ProductService>> getProductServices() async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection('products_services').get();
      return snapshot.docs
          .map((doc) => ProductService.fromMap(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print("Error getting product services: $e");
      throw e;
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
      throw e;
    }
  }

  Future<void> addPrices() async {
    List<ProductService> products = [
      ProductService(id: 'apple', categoryId: 'market', name: 'Elma'),
      ProductService(id: 'bread', categoryId: 'market', name: 'Ekmek'),
      ProductService(id: 'egg', categoryId: 'market', name: 'Yumurta'),
      ProductService(id: 'fruit', categoryId: 'market', name: 'Meyve'),
      ProductService(id: 'vegetable', categoryId: 'market', name: 'Sebze'),
      ProductService(id: 'meat', categoryId: 'market', name: 'Et'),
      ProductService(id: 'cheese', categoryId: 'market', name: 'Peynir'),
      ProductService(id: 'yogurt', categoryId: 'market', name: 'Yoğurt'),
      ProductService(id: 'butter', categoryId: 'market', name: 'Tereyağı'),
      ProductService(
          id: 'toilet_paper', categoryId: 'market', name: 'Tuvalet Kağıdı'),
      ProductService(id: 'bus', categoryId: 'public_transport', name: 'Otobüs'),
      ProductService(
          id: 'metro', categoryId: 'public_transport', name: 'Metro'),
      ProductService(id: 'train', categoryId: 'public_transport', name: 'Tren'),
      ProductService(
          id: 'tram', categoryId: 'public_transport', name: 'Tramvay'),
      ProductService(
          id: 'ferry', categoryId: 'public_transport', name: 'Feribot'),
      ProductService(
          id: 'airplane', categoryId: 'public_transport', name: 'Uçak'),
      ProductService(
          id: 'cheap_restaurant',
          categoryId: 'restaurant',
          name: 'Ucuz Restoran'),
      ProductService(
          id: 'medium_restaurant',
          categoryId: 'restaurant',
          name: 'Orta Restoran'),
      ProductService(
          id: 'expensive_restaurant',
          categoryId: 'restaurant',
          name: 'Pahalı Restoran'),
      ProductService(
          id: 'museum_entry', categoryId: 'museum', name: 'Giriş Ücreti'),
      ProductService(
          id: 'museum_tour', categoryId: 'museum', name: 'Rehberli Tur'),
      ProductService(id: 'museum_exhibit', categoryId: 'museum', name: 'Sergi'),
      ProductService(id: 'benzin', categoryId: 'fuel', name: 'Benzin'),
      ProductService(id: 'hotel', categoryId: 'accommodation', name: 'Otel'),
      ProductService(
          id: 'rental_house', categoryId: 'accommodation', name: 'Kiralık Ev'),
      ProductService(id: 'hostel', categoryId: 'accommodation', name: 'Hostel'),
      ProductService(
          id: 'pension', categoryId: 'accommodation', name: 'Pansiyon'),
      ProductService(id: 'camp', categoryId: 'accommodation', name: 'Kamp'),
    ];

    List<Country> countries = [
      Country(
          id: 'TR',
          name: 'Türkiye',
          currency: 'TRY',
          timezone: 'Europe/Istanbul'),
      Country(
          id: 'FR', name: 'Fransa', currency: 'EUR', timezone: 'Europe/Paris'),
      Country(
          id: 'DE',
          name: 'Almanya',
          currency: 'EUR',
          timezone: 'Europe/Berlin'),
      Country(
          id: 'UK',
          name: 'Birleşik Krallık',
          currency: 'GBP',
          timezone: 'Europe/London'),
      Country(
          id: 'IT', name: 'İtalya', currency: 'EUR', timezone: 'Europe/Rome'),
    ];

    Map<String, double> prices = {
      // Elma fiyatları
      'apple_TR': 10.5,
      'apple_FR': 1.2,
      'apple_DE': 1.1,
      'apple_UK': 0.9,
      'apple_IT': 1.3,

      // Ekmek fiyatları
      'bread_TR': 2.0,
      'bread_FR': 1.0,
      'bread_DE': 0.8,
      'bread_UK': 1.1,
      'bread_IT': 1.2,

      // Yumurta fiyatları
      'egg_TR': 0.5,
      'egg_FR': 0.3,
      'egg_DE': 0.25,
      'egg_UK': 0.4,
      'egg_IT': 0.35,

      // Meyve fiyatları
      'fruit_TR': 5.0,
      'fruit_FR': 4.5,
      'fruit_DE': 4.0,
      'fruit_UK': 4.8,
      'fruit_IT': 4.6,

      // Sebze fiyatları
      'vegetable_TR': 4.0,
      'vegetable_FR': 3.5,
      'vegetable_DE': 3.0,
      'vegetable_UK': 3.8,
      'vegetable_IT': 3.6,

      // Et fiyatları
      'meat_TR': 50.0,
      'meat_FR': 45.0,
      'meat_DE': 40.0,
      'meat_UK': 48.0,
      'meat_IT': 46.0,

      // Peynir fiyatları
      'cheese_TR': 20.0,
      'cheese_FR': 18.0,
      'cheese_DE': 17.0,
      'cheese_UK': 19.0,
      'cheese_IT': 18.5,

      // Yoğurt fiyatları
      'yogurt_TR': 8.0,
      'yogurt_FR': 7.0,
      'yogurt_DE': 6.5,
      'yogurt_UK': 7.5,
      'yogurt_IT': 7.2,

      // Tereyağı fiyatları
      'butter_TR': 15.0,
      'butter_FR': 13.0,
      'butter_DE': 12.0,
      'butter_UK': 14.0,
      'butter_IT': 13.5,

      // Tuvalet Kağıdı fiyatları
      'toilet_paper_TR': 25.0,
      'toilet_paper_FR': 22.0,
      'toilet_paper_DE': 21.0,
      'toilet_paper_UK': 23.0,
      'toilet_paper_IT': 22.5,

      // Toplu Taşıma fiyatları
      'bus_TR': 5.0,
      'bus_FR': 2.0,
      'bus_DE': 2.5,
      'bus_UK': 3.0,
      'bus_IT': 2.8,

      'metro_TR': 5.5,
      'metro_FR': 2.5,
      'metro_DE': 2.8,
      'metro_UK': 3.2,
      'metro_IT': 3.0,

      'train_TR': 15.0,
      'train_FR': 10.0,
      'train_DE': 12.0,
      'train_UK': 15.0,
      'train_IT': 13.0,

      'tram_TR': 4.0,
      'tram_FR': 3.0,
      'tram_DE': 3.5,
      'tram_UK': 4.0,
      'tram_IT': 3.8,

      'ferry_TR': 7.0,
      'ferry_FR': 5.0,
      'ferry_DE': 6.0,
      'ferry_UK': 7.5,
      'ferry_IT': 7.0,

      'airplane_TR': 200.0,
      'airplane_FR': 150.0,
      'airplane_DE': 180.0,
      'airplane_UK': 210.0,
      'airplane_IT': 190.0,

      // Restoran fiyatları
      'cheap_restaurant_TR': 30.0,
      'cheap_restaurant_FR': 20.0,
      'cheap_restaurant_DE': 25.0,
      'cheap_restaurant_UK': 28.0,
      'cheap_restaurant_IT': 26.0,

      'medium_restaurant_TR': 70.0,
      'medium_restaurant_FR': 60.0,
      'medium_restaurant_DE': 55.0,
      'medium_restaurant_UK': 65.0,
      'medium_restaurant_IT': 60.0,

      'expensive_restaurant_TR': 150.0,
      'expensive_restaurant_FR': 120.0,
      'expensive_restaurant_DE': 130.0,
      'expensive_restaurant_UK': 140.0,
      'expensive_restaurant_IT': 135.0,

      // Müze fiyatları
      'museum_entry_TR': 20.0,
      'museum_entry_FR': 18.0,
      'museum_entry_DE': 15.0,
      'museum_entry_UK': 22.0,
      'museum_entry_IT': 20.0,

      'museum_tour_TR': 50.0,
      'museum_tour_FR': 45.0,
      'museum_tour_DE': 40.0,
      'museum_tour_UK': 55.0,
      'museum_tour_IT': 50.0,

      'museum_exhibit_TR': 30.0,
      'museum_exhibit_FR': 28.0,
      'museum_exhibit_DE': 25.0,
      'museum_exhibit_UK': 35.0,
      'museum_exhibit_IT': 30.0,

      // Yakıt fiyatları
      'benzin_TR': 25.0,
      'benzin_FR': 22.0,
      'benzin_DE': 21.0,
      'benzin_UK': 23.0,
      'benzin_IT': 22.5,

      // Konaklama fiyatları
      'hotel_TR': 300.0,
      'hotel_FR': 250.0,
      'hotel_DE': 280.0,
      'hotel_UK': 320.0,
      'hotel_IT': 290.0,

      'rental_house_TR': 500.0,
      'rental_house_FR': 450.0,
      'rental_house_DE': 400.0,
      'rental_house_UK': 550.0,
      'rental_house_IT': 480.0,

      'hostel_TR': 50.0,
      'hostel_FR': 40.0,
      'hostel_DE': 45.0,
      'hostel_UK': 55.0,
      'hostel_IT': 50.0,

      'pension_TR': 150.0,
      'pension_FR': 120.0,
      'pension_DE': 130.0,
      'pension_UK': 140.0,
      'pension_IT': 135.0,

      'camp_TR': 20.0,
      'camp_FR': 18.0,
      'camp_DE': 15.0,
      'camp_UK': 22.0,
      'camp_IT': 20.0,
    };

    try {
      for (var product in products) {
        for (var country in countries) {
          String priceId = '${product.id}_${country.id}';
          double price = prices[priceId] ?? 0.0;

          await _firestore.collection('prices').doc(priceId).set({
            'country_id': country.id,
            'product_service_id': product.id,
            'product_service_name': product.name, // yeni eklenen alan
            'price': price,
            'currency': country.currency,
            'last_updated': FieldValue.serverTimestamp(),
          });
        }
      }
    } catch (e) {
      throw e;
    }
  }
}
