import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyBookingsScreen extends StatefulWidget {
  final int userId;

  const MyBookingsScreen({
    super.key,
    required this.userId,
  });

  @override
  State<MyBookingsScreen> createState() =>
      _MyBookingsScreenState();
}

class _MyBookingsScreenState
    extends State<MyBookingsScreen> {

  List bookings = [];
  bool isLoading = true;

  int selectedTab = 0;

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<void> fetchBookings() async {

    final response = await http.get(
      Uri.parse(
        "http://127.0.0.1:8001/api/bookings/farmer/${widget.userId}",
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

  List getFilteredBookings() {

    if (selectedTab == 0) {
      return bookings;
    }

    if (selectedTab == 1) {
      return bookings
          .where(
            (b) => b["status"] == "PENDING",
          )
          .toList();
    }

    if (selectedTab == 2) {
      return bookings
          .where(
            (b) => b["status"] == "ACCEPTED",
          )
          .toList();
    }

    return bookings
        .where(
          (b) => b["status"] == "REJECTED",
        )
        .toList();
  }

  Widget tabButton(
    String title,
    int index,
  ) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedTab = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 14,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selectedTab == index
                  ? Colors.green
                  : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontWeight: selectedTab == index
                  ? FontWeight.bold
                  : FontWeight.normal,
              color: selectedTab == index
                  ? Colors.green
                  : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final filteredBookings =
        getFilteredBookings();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Bookings"),
        backgroundColor: Colors.green,
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [

                Container(
                  color: Colors.green.shade50,
                  child: Row(
                    children: [

                      Expanded(
                        child: tabButton(
                          "All",
                          0,
                        ),
                      ),

                      Expanded(
                        child: tabButton(
                          "Pending",
                          1,
                        ),
                      ),

                      Expanded(
                        child: tabButton(
                          "Accepted",
                          2,
                        ),
                      ),

                      Expanded(
                        child: tabButton(
                          "Rejected",
                          3,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: filteredBookings.isEmpty
                      ? const Center(
                          child: Text(
                            "No bookings found",
                          ),
                        )
                      : ListView.builder(
                          itemCount:
                              filteredBookings.length,
                          itemBuilder:
                              (context, index) {

                            final booking =
                                filteredBookings[index];

                            return Card(
                              margin:
                                  const EdgeInsets.all(10),

                              child: ListTile(
                                leading: const Icon(
                                  Icons.receipt_long,
                                ),

                                title: Text(
                                  booking["machine_name"],
                                ),

                                subtitle: Text(
                                  "Owner: ${booking["owner_name"]}\n"
                                  "Phone: ${booking["owner_phone"]}\n"
                                  "Harvest Date: ${booking["requested_date"]}\n"
                                  "Acres: ${booking["acres"]}",
                                ),

                                trailing: Text(
                                  booking["status"],
                                  style: TextStyle(
                                    color:
                                        booking["status"] ==
                                                "PENDING"
                                            ? Colors.orange
                                            : booking["status"] ==
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
                        ),
                ),
              ],
            ),
    );
  }
}