class PrevTravel {
  final String id;
  final String country;
  final int numberOfPeople;
  final int numberOfDays;
  final List<String> placesToVisit;
  final bool hasChildren;
  final String imageUrl; // New field for the country's image URL
  final double budgetSpent; // New field for the budget spent

  PrevTravel({
    required this.id,
    required this.country,
    required this.numberOfPeople,
    required this.numberOfDays,
    required this.placesToVisit,
    required this.hasChildren,
    required this.imageUrl, // Initialize the new field
    required this.budgetSpent, // Initialize the new field
  });

  factory PrevTravel.fromFirestore(Map<String, dynamic> firestoreData, String id) {
    return PrevTravel(
      id: id,
      country: firestoreData['country'] ?? '',
      numberOfPeople: firestoreData['numberOfPeople'] ?? 0,
      numberOfDays: firestoreData['numberOfDays'] ?? 0,
      placesToVisit: List.from(firestoreData['placesToVisit'] ?? []),
      hasChildren: firestoreData['hasChildren'] ?? false,
      imageUrl: firestoreData['imageUrl'] ?? '', // Fetch the image URL from Firestore
      budgetSpent: firestoreData['budgetSpent']?.toDouble() ?? 0.0, // Fetch the budget spent from Firestore
    );
  }
}