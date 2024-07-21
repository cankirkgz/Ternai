part of 'previous_trips_screen.dart';

mixin _PreviousTripsScreenMixin on State<PreviousTripsScreen> {

  Future<List<PrevTravel>> fetchUserVacations() async {

    AuthService authService = AuthService();
    final user = (await authService.getCurrentUser());
    if (user == null) {
      throw Exception('User is not logged in');
    }
    final userId = user.userId;

    final recentTravels = FirebaseFirestore.instance.collection('recent_travels');
    final querySnapshot = await recentTravels.where('userId', isEqualTo: userId).get();

    return querySnapshot.docs.map((doc) {
      return PrevTravel.fromFirestore(doc.data(), doc.id);
    }).toList();
  }

}