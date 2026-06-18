import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'edit_machine_screen.dart';

class MyMachinesScreen extends StatefulWidget {
  final int ownerId;

  const MyMachinesScreen({
    super.key,
    required this.ownerId,
  });

  @override
  State<MyMachinesScreen> createState() =>
      _MyMachinesScreenState();
}

class _MyMachinesScreenState
    extends State<MyMachinesScreen> {

  List machines = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMachines();
  }

  Future<void> fetchMachines() async {

    final response = await http.get(
      Uri.parse(
        "http://127.0.0.1:8001/api/machines/owner/${widget.ownerId}",
      ),
    );

    if (response.statusCode == 200) {

      setState(() {
        machines = jsonDecode(response.body);
        isLoading = false;
      });

    } else {

      setState(() {
        isLoading = false;
      });

    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Machines"),
        backgroundColor: Colors.green,
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : machines.isEmpty
              ? const Center(
                  child: Text(
                    "No machines found",
                  ),
                )
              : ListView.builder(
                  itemCount: machines.length,
                  itemBuilder: (context, index) {

                    final machine =
                        machines[index];

                    return Card(
                      margin:
                          const EdgeInsets.all(10),

                      child: Padding(
                        padding:
                            const EdgeInsets.all(12),

                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            Text(
                              machine["machine_name"],
                              style:
                                  const TextStyle(
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(
                              height: 8,
                            ),

                            Text(
                              "Type: ${machine["machine_type"]}",
                            ),

                            Text(
                              "Price: ₹${machine["price_per_acre"]}/Acre",
                            ),

                            Text(
                              "District: ${machine["district"]}",
                            ),

                            Text(
                              "State: ${machine["state"]}",
                            ),

                            Text(
                              "Availability: ${machine["availability"] ? "Available" : "Not Available"}",
                              style: TextStyle(
                                color: machine["availability"]
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            Align(
                              alignment:
                                  Alignment.centerRight,

                              child:
                                  ElevatedButton.icon(
                                icon: const Icon(
                                  Icons.edit,
                                ),

                                label: const Text(
                                  "Edit",
                                ),

                                onPressed: () async {

                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          EditMachineScreen(
                                        machine:
                                            machine,
                                      ),
                                    ),
                                  );

                                  fetchMachines();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}