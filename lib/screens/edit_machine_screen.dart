import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditMachineScreen extends StatefulWidget {
  final Map machine;

  const EditMachineScreen({
    super.key,
    required this.machine,
  });

  @override
  State<EditMachineScreen> createState() =>
      _EditMachineScreenState();
}

class _EditMachineScreenState
    extends State<EditMachineScreen> {

  late TextEditingController nameController;
  late TextEditingController typeController;
  late TextEditingController priceController;
  late TextEditingController districtController;
  late TextEditingController stateController;

  bool availability = true;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
      text: widget.machine["machine_name"],
    );

    typeController = TextEditingController(
      text: widget.machine["machine_type"],
    );

    priceController = TextEditingController(
      text: widget.machine["price_per_acre"].toString(),
    );

    districtController = TextEditingController(
      text: widget.machine["district"],
    );

    stateController = TextEditingController(
      text: widget.machine["state"],
    );

    availability =
        widget.machine["availability"];
  }

  Future<void> updateMachine() async {

    final response = await http.put(
      Uri.parse(
        "https://harvester-backend-5lcq.onrender.com/api/machines/${widget.machine["id"]}",
      ),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "owner_id":
            widget.machine["owner_id"],

        "machine_name":
            nameController.text,

        "machine_type":
            typeController.text,

        "price_per_acre":
            double.parse(
              priceController.text,
            ),

        "district":
            districtController.text,

        "state":
            stateController.text,

        "availability":
            availability,
      }),
    );

    if (response.statusCode == 200) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Machine Updated Successfully",
          ),
        ),
      );

      Navigator.pop(context);

    } else {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Update Failed",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Machine",
        ),
        backgroundColor: Colors.green,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            TextField(
              controller: nameController,
              decoration:
                  const InputDecoration(
                labelText:
                    "Machine Name",
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: typeController,
              decoration:
                  const InputDecoration(
                labelText:
                    "Machine Type",
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: priceController,
              keyboardType:
                  TextInputType.number,
              decoration:
                  const InputDecoration(
                labelText:
                    "Price Per Acre",
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller:
                  districtController,
              decoration:
                  const InputDecoration(
                labelText:
                    "District",
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller:
                  stateController,
              decoration:
                  const InputDecoration(
                labelText:
                    "State",
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SwitchListTile(
              title: const Text(
                "Machine Available",
              ),
              value: availability,
              onChanged: (value) {
                setState(() {
                  availability = value;
                });
              },
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton.icon(
                icon: const Icon(
                  Icons.save,
                ),

                label: const Text(
                  "Save Changes",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),

                onPressed: updateMachine,
              ),
            ),
          ],
        ),
      ),
    );
  }
}