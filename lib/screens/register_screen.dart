import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:harvester_connect_mvp/screens/login_screen.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends State<RegisterScreen> {

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  String selectedRole = "FARMER";

  Future<void> registerUser() async {

    final response = await http.post(
      Uri.parse(
        "http://127.0.0.1:8001/api/auth/register",
      ),

      headers: {
        "Content-Type": "application/json",
      },

      body: jsonEncode({
        "name": nameController.text,
        "phone": phoneController.text,
        "password": passwordController.text,
        "role": selectedRole,
      }),
    );

    if (response.statusCode == 200) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Registration Successful",
          ),
        ),
      );

      Navigator.pop(context);

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Registration Failed",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: "Phone",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: selectedRole,

              items: const [

                DropdownMenuItem(
                  value: "FARMER",
                  child: Text("Farmer"),
                ),

                DropdownMenuItem(
                  value: "OWNER",
                  child: Text("Machine Owner"),
                ),
              ],

              onChanged: (value) {
                setState(() {
                  selectedRole = value!;
                });
              },
            ),

            const SizedBox(height: 25),

            SizedBox(
              // width: double.infinity,

              child: ElevatedButton(
                onPressed: registerUser,
                child: const Text("Register"),
              ),
            ),
            const SizedBox(height: 25),

            SizedBox(
              // width: double.infinity,

              child: ElevatedButton(
                onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                );
              },
                child: const Text("Already have Account"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}