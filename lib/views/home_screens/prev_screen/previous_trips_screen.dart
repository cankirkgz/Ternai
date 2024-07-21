import 'package:flutter/material.dart';
import 'package:travelguide/models/prev_travel_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travelguide/services/auth_service.dart';

part 'previous_trips_screen_mixin.dart';

class PreviousTripsScreen extends StatefulWidget {

  const PreviousTripsScreen({super.key});

  @override
  State<PreviousTripsScreen> createState() => _PreviousTripsScreenState();
}

class _PreviousTripsScreenState extends State<PreviousTripsScreen> with _PreviousTripsScreenMixin {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('Önceki Tatil Planlarım'),
      ),
      body: FutureBuilder<List<PrevTravel>>(
        future: fetchUserVacations(), // Use the fetch function here
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching vacations'));
          } else if (snapshot.hasData) {
            final vacations = snapshot.data!;
            return ListView.builder(
              itemCount: vacations.length,
              itemBuilder: (context, index) {
                final vacation = vacations[index];
                return Container(
                  margin: const EdgeInsets.only(top: 10.0, right: 30, left: 30.0),
                  height: 200,
                  decoration: const BoxDecoration(boxShadow: [
                    BoxShadow(blurRadius: 10, color: Colors.grey, offset: Offset.zero)
                  ]),
                  child: Card(
                    color: const Color.fromARGB(255, 170, 210, 230),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Image.network(
                          vacation.imageUrl,
                          height: 120,
                          fit: BoxFit.fill,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                          child: Text(
                            textAlign: TextAlign.center,
                            '${vacation.country} - ${vacation.numberOfPeople} kişi için ${vacation.numberOfDays} günlük tatil. Bütçe: ${vacation.budgetSpent}\$',
                            style: TextStyle(
                              color: Colors.grey[900],
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No vacations found'));
          }
        },
      ),
    );
  }
}