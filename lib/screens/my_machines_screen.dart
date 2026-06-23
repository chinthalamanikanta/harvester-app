import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'edit_machine_screen.dart';
import 'add_machine_screen.dart';


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
        "https://harvester-backend-5lcq.onrender.com/api/machines/owner/${widget.ownerId}",
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

    floatingActionButton: FloatingActionButton.extended(
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.add),
      label: const Text("Add Machine"),
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddMachineScreen(
              ownerId: widget.ownerId,
            ),
          ),
        );

        fetchMachines();
      },
    ),

    body: isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )

        : machines.isEmpty

            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [

                      Icon(
                        Icons.agriculture,
                        size: 100,
                        color: Colors.green.shade400,
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "No Machines Added Yet",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "Add your harvester machine and start receiving bookings from farmers.",
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 25),

                      ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text(
                          "Add Machine",
                        ),
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.green,
                          foregroundColor:
                              Colors.white,
                        ),
                        onPressed: () async {

                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  AddMachineScreen(
                                ownerId:
                                    widget.ownerId,
                              ),
                            ),
                          );

                          fetchMachines();
                        },
                      ),
                    ],
                  ),
                ),
              )

            : RefreshIndicator(
                onRefresh: fetchMachines,
                child: ListView.builder(
                  itemCount: machines.length,

                  itemBuilder: (context, index) {

                    final machine =
                        machines[index];

                    return Card(
                      elevation: 4,
                      margin:
                          const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          15,
                        ),
                      ),

                      child: Padding(
                        padding:
                            const EdgeInsets.all(15),

                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            Row(
                              children: [

                                CircleAvatar(
                                  backgroundColor:
                                      Colors.green,
                                  child: const Icon(
                                    Icons.agriculture,
                                    color:
                                        Colors.white,
                                  ),
                                ),

                                const SizedBox(
                                  width: 12,
                                ),

                                Expanded(
                                  child: Text(
                                    machine[
                                        "machine_name"],
                                    style:
                                        const TextStyle(
                                      fontSize:
                                          20,
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const Divider(
                              height: 25,
                            ),

                            Text(
                              "Type: ${machine["machine_type"]}",
                            ),

                            const SizedBox(
                              height: 5,
                            ),

                            Text(
                              "Price: ₹${machine["price_per_acre"]}/Acre",
                            ),

                            const SizedBox(
                              height: 5,
                            ),

                            Text(
                              "District: ${machine["district"]}",
                            ),

                            const SizedBox(
                              height: 5,
                            ),

                            Text(
                              "State: ${machine["state"]}",
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            Container(
                              padding:
                                  const EdgeInsets
                                      .symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),

                              decoration:
                                  BoxDecoration(
                                color: machine[
                                        "availability"]
                                    ? Colors.green
                                        .shade100
                                    : Colors.red
                                        .shade100,

                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  20,
                                ),
                              ),

                              child: Text(
                                machine[
                                        "availability"]
                                    ? "Available"
                                    : "Not Available",

                                style:
                                    TextStyle(
                                  color: machine[
                                          "availability"]
                                      ? Colors
                                          .green
                                      : Colors.red,

                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 15,
                            ),

                            Align(
                              alignment:
                                  Alignment
                                      .centerRight,

                              child:
                                  ElevatedButton.icon(
                                icon:
                                    const Icon(
                                  Icons.edit,
                                ),

                                label:
                                    const Text(
                                  "Edit Machine",
                                ),

                                style:
                                    ElevatedButton
                                        .styleFrom(
                                  backgroundColor:
                                      Colors
                                          .green,
                                  foregroundColor:
                                      Colors
                                          .white,
                                ),

                                onPressed:
                                    () async {

                                  await Navigator
                                      .push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) =>
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
              ),
  );
}
}