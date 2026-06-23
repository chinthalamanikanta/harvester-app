import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OwnerBookingsScreen extends StatefulWidget {
  final int ownerId;

  const OwnerBookingsScreen({
    super.key,
    required this.ownerId, required userId,
  });

  @override
  State<OwnerBookingsScreen> createState() =>
      _OwnerBookingsScreenState();
}

class _OwnerBookingsScreenState
    extends State<OwnerBookingsScreen>
    with SingleTickerProviderStateMixin {

  List bookings = [];
  bool isLoading = true;

  late TabController tabController;

  @override
  void initState() {
    super.initState();

    tabController = TabController(
      length: 4,
      vsync: this,
    );

    fetchBookings();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Future<void> fetchBookings() async {

    final response = await http.get(
      Uri.parse(
        "https://harvester-backend-5lcq.onrender.com/api/bookings/owner/${widget.ownerId}",
      ),
    );

    if (response.statusCode == 200) {

      setState(() {
        bookings = jsonDecode(response.body);
        isLoading = false;
      });

    } else {

      setState(() {
        isLoading = false;
      });

    }
  }

  Future<void> updateBooking(
    int bookingId,
    String action,
  ) async {

    await http.put(
      Uri.parse(
        "https://harvester-backend-5lcq.onrender.com/api/bookings/$bookingId/$action",
      ),
    );

    fetchBookings();
  }

  List getFilteredBookings(String status) {

    if (status == "ALL") {
      return bookings;
    }

    return bookings.where((booking) {
      return booking["status"] == status;
    }).toList();
  }

  Widget buildBookingList(List filteredBookings) {

    if (filteredBookings.isEmpty) {
      return const Center(
        child: Text(
          "No bookings found",
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredBookings.length,

      itemBuilder: (context, index) {

        final booking = filteredBookings[index];

        return Card(
          margin: const EdgeInsets.all(10),

          child: ListTile(
            leading: const Icon(
              Icons.agriculture,
            ),

            title: Text(
              booking["machine_name"],
            ),

            subtitle: Text(
              "Farmer: ${booking["farmer_name"]}\n"
              "Phone: ${booking["farmer_phone"]}\n"
              "Acres: ${booking["acres"]}\n"
              "Harvest Date: ${booking["requested_date"] ?? "N/A"}",
            ),

            trailing: booking["status"] == "PENDING"
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      IconButton(
                        icon: const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                        onPressed: () {
                          updateBooking(
                            booking["id"],
                            "accept",
                          );
                        },
                      ),

                      IconButton(
                        icon: const Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          updateBooking(
                            booking["id"],
                            "reject",
                          );
                        },
                      ),
                    ],
                  )
                : Text(
                    booking["status"],
                    style: TextStyle(
                      color: booking["status"] ==
                              "ACCEPTED"
                          ? Colors.green
                          : Colors.red,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Booking Requests",
        ),
        backgroundColor: Colors.white,

        bottom: TabBar(
          controller: tabController,
          isScrollable: true,

          tabs: const [
            Tab(text: "All"),
            Tab(text: "Pending"),
            Tab(text: "Accepted"),
            Tab(text: "Rejected"),
          ],
        ),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : TabBarView(
              controller: tabController,
              children: [

                buildBookingList(
                  getFilteredBookings("ALL"),
                ),

                buildBookingList(
                  getFilteredBookings("PENDING"),
                ),

                buildBookingList(
                  getFilteredBookings("ACCEPTED"),
                ),

                buildBookingList(
                  getFilteredBookings("REJECTED"),
                ),
              ],
            ),
    );
  }
}