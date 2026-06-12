import 'package:flutter/material.dart';
import 'available_harvesters_screen.dart';
class CreateBookingScreen extends StatefulWidget {
  const CreateBookingScreen({super.key});

  @override
  State<CreateBookingScreen> createState() => _CreateBookingScreenState();
}

class _CreateBookingScreenState extends State<CreateBookingScreen> {
  String selectedState = "Andhra Pradesh";
  String selectedDistrict = "West Godavari";

  final TextEditingController acresController =
      TextEditingController();

  final List<String> states = [
    "Andhra Pradesh",
    "Telangana",
  ];

  final List<String> districts = [
    "West Godavari",
    "East Godavari",
    "Krishna",
    "Guntur",
    "Nizamabad",
    "Karimnagar",
    "Warangal",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Corn Harvester"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              enabled: false,
              decoration: InputDecoration(
                labelText: "Crop Type",
                border: OutlineInputBorder(),
                hintText: "Corn",
              ),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField(
              value: selectedState,
              decoration: const InputDecoration(
                labelText: "State",
                border: OutlineInputBorder(),
              ),
              items: states.map((state) {
                return DropdownMenuItem(
                  value: state,
                  child: Text(state),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedState = value!;
                });
              },
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField(
              value: selectedDistrict,
              decoration: const InputDecoration(
                labelText: "District",
                border: OutlineInputBorder(),
              ),
              items: districts.map((district) {
                return DropdownMenuItem(
                  value: district,
                  child: Text(district),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDistrict = value!;
                });
              },
            ),

            const SizedBox(height: 15),

            TextField(
              controller: acresController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Acres",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.search),
                label: const Text(
                  "Find Harvesters",
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const AvailableHarvestersScreen(),
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