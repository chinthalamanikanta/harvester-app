import 'package:flutter/material.dart';
import 'available_harvesters_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'my_bookings_screen.dart';

class CreateBookingScreen extends StatefulWidget {
  final int machineId;
final String machineName;
 final int farmerId;

const CreateBookingScreen({
  super.key,
  required this.machineId,
  required this.machineName,
  required this.farmerId,
});

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

  DateTime? selectedDate;

  bool get isFormValid {
  return acresController.text.trim().isNotEmpty &&
      selectedDate != null;
}

@override
void initState() {
  super.initState();

  acresController.addListener(() {
    setState(() {});
  });
}

  Future<void> createBooking() async {
    final acres = double.tryParse(acresController.text);

    if (acres == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Enter valid acres"),
        ),
      );
      return;
    }

    final response = await http.post(
      Uri.parse(
        "https://harvester-backend-5lcq.onrender.com/api/bookings/create",
      ),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "farmer_id": widget.farmerId,
        "machine_id": widget.machineId,
        "acres": acres,
        "booking_date":
            DateTime.now().toIso8601String().split("T")[0],
            "requested_date":
      selectedDate!.toIso8601String().split("T")[0],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Booking Created (#${data["booking_id"]})",
          ),
        ),
      );

      Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (_) => MyBookingsScreen(
      userId: widget.farmerId,
    ),
  ),
);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Booking Failed"),
        ),
      );
    }
}

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

            // const SizedBox(height: 15),

            // DropdownButtonFormField(
            //   value: selectedState,
            //   decoration: const InputDecoration(
            //     labelText: "State",
            //     border: OutlineInputBorder(),
            //   ),
            //   items: states.map((state) {
            //     return DropdownMenuItem(
            //       value: state,
            //       child: Text(state),
            //     );
            //   }).toList(),
            //   onChanged: (value) {
            //     setState(() {
            //       selectedState = value!;
            //     });
            //   },
            // ),

            // const SizedBox(height: 15),

            // DropdownButtonFormField(
            //   value: selectedDistrict,
            //   decoration: const InputDecoration(
            //     labelText: "District",
            //     border: OutlineInputBorder(),
            //   ),
            //   items: districts.map((district) {
            //     return DropdownMenuItem(
            //       value: district,
            //       child: Text(district),
            //     );
            //   }).toList(),
            //   onChanged: (value) {
            //     setState(() {
            //       selectedDistrict = value!;
            //     });
            //   },
            // ),
            Card(
  child: ListTile(
    leading: const Icon(Icons.agriculture),
    title: Text(widget.machineName),
    subtitle: Text(
      "Machine ID: ${widget.machineId}",
    ),
  ),
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

            ElevatedButton(
  onPressed: () async {

    DateTime? pickedDate =
        await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  },
  child: Text(
    selectedDate == null
        ? "Select Harvest Date"
        : selectedDate.toString().split(" ")[0],
  ),
),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.search),
                label: const Text(
                  "Submit Booking",
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: isFormValid
                  ? createBooking
                  : null,
                
              ),
            ),
          ],
        ),
      ),
    );
  }
}