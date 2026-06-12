import 'package:flutter/material.dart';

class AvailableHarvestersScreen extends StatelessWidget {
  const AvailableHarvestersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Harvesters"),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          harvesterCard(
            context,
            "Ravi Harvester Services",
            "West Godavari",
            "₹2200/Acre",
            "4.8",
          ),
          harvesterCard(
            context,
            "Mahesh Agro Machines",
            "Krishna",
            "₹2500/Acre",
            "4.7",
          ),
          harvesterCard(
            context,
            "Suresh Harvest Solutions",
            "Guntur",
            "₹2300/Acre",
            "4.9",
          ),
        ],
      ),
    );
  }

  Widget harvesterCard(
    BuildContext context,
    String name,
    String district,
    String price,
    String rating,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.agriculture),
              ),
              title: Text(name),
              subtitle: Text(district),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text("⭐ $rating"),
              ],
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text("Book Now"),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Booking Successful"),
                      content: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 60,
                          ),
                          SizedBox(height: 10),
                          Text("Booking ID: HC1025"),
                          Text("Status: Pending"),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("OK"),
                        )
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}