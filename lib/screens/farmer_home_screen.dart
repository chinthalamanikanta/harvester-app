import 'package:flutter/material.dart';
import 'create_booking_screen.dart';
class FarmerHomeScreen extends StatelessWidget {
  const FarmerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Farmer Dashboard"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome, Ramesh 🌽",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Andhra Pradesh",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.agriculture),
                label: const Text(
                  "Book Corn Harvester",
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const CreateBookingScreen(),
    ),
  );
                }
                ,
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Available Harvesters",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: ListView(
                children: const [
                  HarvesterCard(
                    name: "Ravi Harvester",
                    location: "West Godavari",
                    price: "₹2200/Acre",
                  ),
                  HarvesterCard(
                    name: "Mahesh Harvester",
                    location: "Krishna",
                    price: "₹2500/Acre",
                  ),
                  HarvesterCard(
                    name: "Suresh Harvester",
                    location: "Guntur",
                    price: "₹2300/Acre",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HarvesterCard extends StatelessWidget {
  final String name;
  final String location;
  final String price;

  const HarvesterCard({
    super.key,
    required this.name,
    required this.location,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.agriculture),
        ),
        title: Text(name),
        subtitle: Text(location),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(price),
            const SizedBox(height: 4),
            const Text(
              "4.8 ⭐",
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}