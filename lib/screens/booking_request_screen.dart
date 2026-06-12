import 'package:flutter/material.dart';

class BookingRequestsScreen extends StatelessWidget {
  const BookingRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking Requests"),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          bookingCard(
            "Ramesh",
            "West Godavari",
            "5 Acres",
          ),
          bookingCard(
            "Mahesh",
            "Krishna",
            "8 Acres",
          ),
        ],
      ),
    );
  }

  Widget bookingCard(
    String farmer,
    String district,
    String acres,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            ListTile(
              title: Text(farmer),
              subtitle: Text("$district • $acres"),
            ),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Accept"),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Reject"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}