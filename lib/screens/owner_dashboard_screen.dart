import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'owner_bookings_screen.dart';
import 'my_machines_screen.dart';

class OwnerDashboardScreen extends StatefulWidget {
  final int userId;

  const OwnerDashboardScreen({
    super.key,
    required this.userId,
  });

  @override
  State<OwnerDashboardScreen> createState() =>
      _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState
    extends State<OwnerDashboardScreen> {

  bool isLoading = true;
  

  int totalBookings = 0;
  int pendingRequests = 0;
  int acceptedJobs = 0;
  double earnings = 0;

  @override
  void initState() {
    super.initState();
    fetchDashboardStats();
  }

  Future<void> fetchDashboardStats() async {

    final response = await http.get(
      Uri.parse(
        "http://127.0.0.1:8001/api/bookings/owner/${widget.userId}/stats",
      ),
    );

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      setState(() {
        totalBookings =
            data["total_bookings"];

        pendingRequests =
            data["pending_requests"];

        acceptedJobs =
            data["accepted_jobs"];

        earnings =
            data["earnings"].toDouble();

        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Machine Owner Dashboard",
        ),
        backgroundColor: Colors.green,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: SingleChildScrollView(
          child: Column(
            children: [

              dashboardCard(
                "Total Bookings",
                totalBookings.toString(),
                Icons.book_online,
              ),

              dashboardCard(
                "Pending Requests",
                pendingRequests.toString(),
                Icons.pending_actions,
              ),

              dashboardCard(
                "Accepted Jobs",
                acceptedJobs.toString(),
                Icons.check_circle,
              ),

              dashboardCard(
                "Total Earnings",
                "₹${earnings.toStringAsFixed(0)}",
                Icons.currency_rupee,
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton.icon(
                  icon: const Icon(
                    Icons.receipt_long,
                  ),

                  label: const Text(
                    "Booking Requests",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),

                  onPressed: () {

                    Navigator.push( context, MaterialPageRoute( builder: (_) => OwnerBookingsScreen(ownerId: widget.userId, userId: widget.userId,), ), );
                  },
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton.icon(
                  icon: const Icon(
                    Icons.agriculture,
                  ),

                  label: const Text(
                    "My Machines",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),

                  onPressed: () {
                    Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => MyMachinesScreen(
        ownerId: widget.userId,
      ),
    ),
  );
                    // Next screen
                  },
                ),
              ),
            ],
          ),
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
      margin: const EdgeInsets.only(
        bottom: 15,
      ),

      child: ListTile(
        leading: Icon(
          icon,
          size: 40,
        ),

        title: Text(title),

        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),
    );
  }
}