import 'package:flutter/material.dart';
import '../models/machine.dart';
import '../services/machine_service.dart';
import 'create_booking_screen.dart';

class FarmerHomeScreen extends StatefulWidget {
  final int userId;
  const FarmerHomeScreen({super.key,required this.userId,});

  @override
  State<FarmerHomeScreen> createState() =>
      _FarmerHomeScreenState();
}

class _FarmerHomeScreenState
    extends State<FarmerHomeScreen> {

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
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(
              "Welcome, Farmer 🌽",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Andhra Pradesh / Telangana",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),

            // const SizedBox(height: 20),

            // SizedBox(
            //   width: double.infinity,
            //   height: 60,

            //   child: ElevatedButton.icon(
            //     icon: const Icon(
            //       Icons.agriculture,
            //     ),

            //     label: const Text(
            //       "Book Corn Harvester",
            //       style: TextStyle(
            //         fontSize: 18,
            //       ),
            //     ),

            //     onPressed: () {

            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (_) =>
            //               const CreateBookingScreen(
// machineId: 1,
//       machineName: "John Deere Harvester",
            //               ),
            //         ),
            //       );
            //     },
            //   ),
            // ),

            const SizedBox(height: 30),

            const Text(
              "Available Harvesters",
              style: TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: FutureBuilder<List<Machine>>(
                future:
                    MachineService.getMachines(),

                builder:
                    (context, snapshot) {

                  if (snapshot
                          .connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child:
                          CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        snapshot.error
                            .toString(),
                      ),
                    );
                  }

                  final machines =
                      snapshot.data ?? [];

                  if (machines.isEmpty) {
                    return const Center(
                      child: Text(
                        "No machines available",
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount:
                        machines.length,

                    itemBuilder:
                        (context, index) {

                      final machine =
                          machines[index];

                      return Card(
                        margin:
                            const EdgeInsets.only(
                          bottom: 12,
                        ),

                        child: ListTile(
                          leading:
                              const CircleAvatar(
                            child: Icon(
                              Icons.agriculture,
                            ),
                          ),

                          title: Text(
                            machine.machineName,
                          ),

                          subtitle: Text(
                            "${machine.machineType}\n${machine.district}, ${machine.state}",
                          ),

                          isThreeLine: true,

                          trailing: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,

                            children: [

                              Text(
                                "₹${machine.pricePerAcre}",
                                style:
                                    const TextStyle(
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              const SizedBox(
                                height: 5,
                              ),

                              SizedBox(
                                height: 27,

                                child:
                                    ElevatedButton(
                                  onPressed:
                                      () {

                                    Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => CreateBookingScreen(
      machineId: machine.id,
      machineName: machine.machineName,
      farmerId: widget.userId,
    ),
  ),
);
                                  },

                                  child:
                                      const Text(
                                    "Book",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}