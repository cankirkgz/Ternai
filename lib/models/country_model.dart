class Country {
  String id;
  String name;
  String currency;
  String timezone;

  Country({
    required this.id,
    required this.name,
    required this.currency,
    required this.timezone,
  });

  factory Country.fromMap(Map<String, dynamic> data, String documentId) {
    return Country(
      id: data['countryId'] ??
          documentId, // 'countryId' yoksa documentId kullan
      name: data['name'] ?? '',
      currency: data['currency'] ?? '',
      timezone: data['timezone'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'countryId': id,
      'name': name,
      'currency': currency,
      'timezone': timezone,
    };
  }
}
