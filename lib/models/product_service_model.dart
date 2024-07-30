class ProductModel {
  String id;
  String categoryId;
  String name;

  ProductModel(
      {required this.id, required this.categoryId, required this.name});

  factory ProductModel.fromMap(Map<String, dynamic> data, String documentId) {
    return ProductModel(
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
