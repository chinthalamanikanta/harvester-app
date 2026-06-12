import 'package:flutter/material.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Bookings"),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          bookingCard(
            "HC1025",
            "Ravi Harvester",
            "Pending",
          ),
          bookingCard(
            "HC1024",
            "Mahesh Agro",
            "Completed",
          ),
        ],
      ),
    );
  }

  Widget bookingCard(
    String id,
    String owner,
    String status,
  ) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.receipt),
        title: Text(id),
        subtitle: Text(owner),
        trailing: Text(status),
      ),
    );
  }
}