class ProductService {
  String id;
  String categoryId;
  String name;

  ProductService(
      {required this.id, required this.categoryId, required this.name});

  factory ProductService.fromMap(Map<String, dynamic> data, String documentId) {
    return ProductService(
      id: documentId,
      categoryId: data['category_id'],
      name: data['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category_id': categoryId,
      'name': name,
    };
  }
}
