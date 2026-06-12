import 'package:flutter/material.dart';

class OwnerDashboardScreen extends StatelessWidget {
  const OwnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Machine Owner Dashboard"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            dashboardCard(
              "Total Bookings",
              "25",
              Icons.book_online,
            ),

            dashboardCard(
              "Pending Requests",
              "5",
              Icons.pending_actions,
            ),

            dashboardCard(
              "Completed Jobs",
              "20",
              Icons.check_circle,
            ),

            dashboardCard(
              "Monthly Earnings",
              "₹1,25,000",
              Icons.currency_rupee,
            ),
          ],
        ),
      ),
    );
  }

  Widget dashboardCard(
    String title,
    String value,
    IconData icon,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: Icon(icon, size: 40),
        title: Text(title),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}