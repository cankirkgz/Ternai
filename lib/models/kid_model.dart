class KidModel {
  final String id;
  final String gender;
  final int age;

  KidModel({required this.id, required this.gender, required this.age});

  // JSON'dan KidModel'e dönüşüm
  factory KidModel.fromJson(Map<String, dynamic> json) {
    return KidModel(
      id: json['id'],
      gender: json['gender'],
      age: json['age'],
    );
  }

  // KidModel'den JSON'a dönüşüm
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gender': gender,
      'age': age,
    };
  }
}
