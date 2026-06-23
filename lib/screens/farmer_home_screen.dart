import 'package:flutter/material.dart';
import '../models/machine.dart';
import '../services/machine_service.dart';
import 'create_booking_screen.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';

class FarmerHomeScreen extends StatefulWidget {
  final int userId;

  const FarmerHomeScreen({
    super.key,
    required this.userId,
  });

  @override
  State<FarmerHomeScreen> createState() =>
      _FarmerHomeScreenState();
}

class _FarmerHomeScreenState
    extends State<FarmerHomeScreen> {

  String selectedState = "";
  String selectedDistrict = "";

  List<Machine> allMachines = [];
  List<Machine> filteredMachines = [];

  String currentState = "";
String currentDistrict = "";

bool locationLoading = false;

  final List<String> states = [
    "Andhra Pradesh",
    "Telangana",
  ];

  final Map<String, List<String>> districts = {
    "Andhra Pradesh": [
      "Anantapur",
      "Kurnool",
      "Guntur",
      "Vijayawada",
      "West Godavari",
      "East Godavari",
    ],

    "Telangana": [
      "Hyderabad",
      "Warangal",
      "Karimnagar",
      "Nizamabad",
      "Khammam",
    ],
  };

  @override
  void initState() {
    super.initState();
    loadMachines();
  }

  void filterByLocation() {

  filteredMachines =
      allMachines.where((machine) {

    return machine.state
            .toLowerCase()
            .contains(
              currentState.toLowerCase(),
            ) &&
        machine.district
            .toLowerCase()
            .contains(
              currentDistrict.toLowerCase(),
            );

  }).toList();

  setState(() {});
}


//   Future<void> getCurrentLocation() async {

//   setState(() {
//     locationLoading = true;
//   });

//   LocationPermission permission =
//       await Geolocator.checkPermission();

//   if (permission == LocationPermission.denied) {
//     permission =
//         await Geolocator.requestPermission();
//   }

//   Position position =
//       await Geolocator.getCurrentPosition(
//     desiredAccuracy: LocationAccuracy.high,
//   );
//   try {
//   List<Placemark> placemarks =
//       await placemarkFromCoordinates(
//     position.latitude,
//     position.longitude,
//   );

//   if (placemarks.isNotEmpty) {
//     final place = placemarks.first;

//     setState(() {
//       currentState =
//           place.administrativeArea ?? "";

//       currentDistrict =
//           place.subAdministrativeArea ?? "";
//     });
//   }
// } catch (e) {
//   print("GEOCODING ERROR: $e");
// }
//   print("LAT = ${position.latitude}");
// print("LNG = ${position.longitude}");

//   List<Placemark> placemarks =
//       await placemarkFromCoordinates(
//     position.latitude,
//     position.longitude,
//   );

//   Placemark place = placemarks.first;

//   setState(() {

//     currentState =
//         place.administrativeArea ?? "";

//     currentDistrict =
//         place.subAdministrativeArea ?? "";

//     locationLoading = false;
//   });

//   filterByLocation();
// }

  Future<void> loadMachines() async {

    final machines =
        await MachineService.getMachines();

    setState(() {
      allMachines = machines;
      filteredMachines = machines;
    });
  }

  void filterMachines() {

    setState(() {

      filteredMachines = allMachines.where((machine) {

        bool stateMatch =
            selectedState.isEmpty ||
                machine.state == selectedState;

        bool districtMatch =
            selectedDistrict.isEmpty ||
                machine.district ==
                    selectedDistrict;

        return stateMatch &&
            districtMatch;

      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Farmer Dashboard",
        ),
        backgroundColor: Colors.green,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(
              "Welcome Farmer 🌾",
              style: TextStyle(
                fontSize: 24,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            /// STATE DROPDOWN

            DropdownButtonFormField<String>(
              value: selectedState.isEmpty
                  ? null
                  : selectedState,

              decoration:
                  const InputDecoration(
                labelText: "Select State",
                border:
                    OutlineInputBorder(),
              ),

              items: states.map((state) {

                return DropdownMenuItem(
                  value: state,
                  child: Text(state),
                );

              }).toList(),

              onChanged: (value) {

                setState(() {

                  selectedState =
                      value ?? "";

                  selectedDistrict = "";

                });

                filterMachines();
              },
            ),

            const SizedBox(height: 15),

            /// DISTRICT DROPDOWN

            DropdownButtonFormField<String>(
              value:
                  selectedDistrict.isEmpty
                      ? null
                      : selectedDistrict,

              decoration:
                  const InputDecoration(
                labelText:
                    "Select District",
                border:
                    OutlineInputBorder(),
              ),

              items: selectedState.isEmpty
                  ? []
                  : districts[selectedState]!
                      .map((district) {

                      return DropdownMenuItem(
                        value: district,
                        child: Text(district),
                      );

                    }).toList(),

              onChanged: (value) {

                setState(() {
                  selectedDistrict =
                      value ?? "";
                });

                filterMachines();
              },
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(
                icon: const Icon(
                  Icons.search,
                ),

                label: const Text(
                  "Search Machines",
                ),

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.green,
                  foregroundColor:
                      Colors.white,
                ),

                onPressed: filterMachines,
              ),
            ),
// SizedBox(
//   width: double.infinity,

//   child: ElevatedButton.icon(
//     icon: const Icon(Icons.my_location),

//     label: Text(
//       locationLoading
//           ? "Detecting Location..."
//           : "Use My Location",
//     ),

//     style: ElevatedButton.styleFrom(
//       backgroundColor: Colors.green,
//       foregroundColor: Colors.white,
//     ),

//     onPressed: locationLoading
//         ? null
//         : getCurrentLocation,
//   ),
// ),
            const SizedBox(height: 25),

            const Text(
              "Available Harvesters",
              style: TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            if (currentDistrict.isNotEmpty)
  Padding(
    padding:
        const EdgeInsets.symmetric(
      vertical: 10,
    ),

    child: Text(
      "📍 $currentDistrict, $currentState",
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
    ),
  ),

            const SizedBox(height: 10),

            Expanded(
              child: filteredMachines.isEmpty

                  ? const Center(
                      child: Text(
                        "No Machines Found",
                      ),
                    )

                  : ListView.builder(
                      itemCount:
                          filteredMachines
                              .length,

                      itemBuilder:
                          (context, index) {

                        final machine =
                            filteredMachines[
                                index];

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
                              "${machine.machineType}\n"
                              "${machine.district}, ${machine.state}",
                            ),

                            isThreeLine: true,

                            trailing: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .center,

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
                                  height: 3,
                                ),

                                SizedBox(
                                  height: 28,

                                  child:
                                      ElevatedButton(
                                    onPressed:
                                        () {

                                      Navigator.push(
                                        context,

                                        MaterialPageRoute(
                                          builder:
                                              (_) =>
                                                  CreateBookingScreen(
                                            machineId:
                                                machine.id,

                                            machineName:
                                                machine.machineName,

                                            farmerId:
                                                widget.userId,
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
                    ),
            ),
          ],
        ),
      ),
    );
  }
}