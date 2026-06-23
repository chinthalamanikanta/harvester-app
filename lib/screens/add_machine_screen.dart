import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddMachineScreen extends StatefulWidget {
  final int ownerId;

  const AddMachineScreen({
    super.key,
    required this.ownerId,
  });

  @override
  State<AddMachineScreen> createState() =>
      _AddMachineScreenState();
}

class _AddMachineScreenState
    extends State<AddMachineScreen> {

  final _formKey = GlobalKey<FormState>();

  final machineNameController =
      TextEditingController();

  final priceController =
      TextEditingController();
  final districtController =
    TextEditingController();
  final stateController =
    TextEditingController(
  
);

  String machineType = "Harvester";
  String state = "Andhra Pradesh";
  String district = "";
  bool isLoading = false;

  Future<void> addMachine() async {

  if (!_formKey.currentState!.validate()) {
    return;
  }

  if (isLoading) return;

  setState(() {
    isLoading = true;
  });

  try {

    final response = await http.post(
      Uri.parse(
        "https://harvester-backend-5lcq.onrender.com/api/machines/add",
      ),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "owner_id": widget.ownerId,
        "machine_name":
            machineNameController.text.trim(),
        "machine_type": machineType,
        "price_per_acre":
            double.parse(priceController.text),
        "state": stateController.text.trim(),
"district": districtController.text.trim(),
        "availability": true,
      }),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201) {

      Navigator.pop(context, true);

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Failed to add machine",
          ),
        ),
      );
    }

  } catch (e) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error: $e"),
      ),
    );

  } finally {

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }
}

@override
void dispose() {
  machineNameController.dispose();
  priceController.dispose();
  districtController.dispose();
  stateController.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Machine"),
        backgroundColor: Colors.green,
      ),

      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
        
          child: Column(
            children: [
        
              TextFormField(
          controller: machineNameController,
        
          decoration: const InputDecoration(
            labelText: "Machine Name",
            border: OutlineInputBorder(),
          ),
        
          validator: (value) {
            if (value == null ||
          value.trim().isEmpty) {
        return "Please enter machine name";
            }
            return null;
          },
        ),
        
              const SizedBox(height: 15),
        
              TextFormField(
          controller: priceController,
        
          keyboardType: TextInputType.number,
        
          decoration: const InputDecoration(
            labelText: "Price Per Acre",
            border: OutlineInputBorder(),
          ),
        
          validator: (value) {
            if (value == null ||
          value.trim().isEmpty) {
        return "Please enter price";
            }
        
            if (double.tryParse(value) == null) {
        return "Enter valid price";
            }
        
            return null;
          },
        ),
        
              const SizedBox(height: 15),
        
              TextFormField(
          decoration: const InputDecoration(
            labelText: "District",
            border: OutlineInputBorder(),
          ),
        
          onChanged: (value) {
            district = value;
          },
        
          validator: (value) {
            if (value == null ||
          value.trim().isEmpty) {
        return "Please enter district";
            }
            return null;
          },
        ),
              const SizedBox(height: 15),
        
              TextFormField(
          decoration: const InputDecoration(
            labelText: "State",
            border: OutlineInputBorder(),
          ),
        
          onChanged: (value) {
            state = value;
          },
        
          validator: (value) {
            if (value == null ||
          value.trim().isEmpty) {
        return "Please enter state";
            }
            return null;
          },
        ),
        
              const SizedBox(height: 30),
        
        SizedBox(
          width: double.infinity,
          height: 55,
        
          child: ElevatedButton(
            onPressed: isLoading
          ? null
          : addMachine,
        
            style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
            ),
        
            child: isLoading
          ? const Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
        
                SizedBox(
                  width: 20,
                  height: 20,
                  child:
                      CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
        
                SizedBox(width: 12),
        
                Text("Adding Machine..."),
              ],
            )
          : const Text(
              "Add Machine",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
            ],
          ),
        ),
      ),
    );
  }
}