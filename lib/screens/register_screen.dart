import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:harvester_connect_mvp/screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

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
  // final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String selectedRole = "FARMER";

  Future<void> registerUser() async {
    final phone = phoneController.text.trim();

  if (!RegExp(r'^[0-9]{10}$').hasMatch(phone)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Phone number must be exactly 10 digits",
        ),
      ),
    );
    return;
  }

    final response = await http.post(
      Uri.parse(
        "https://harvester-backend-5lcq.onrender.com/api/auth/register",
      ),

      headers: {
        "Content-Type": "application/json",
      },

      body: jsonEncode({
        "name": nameController.text,
        "phone": phoneController.text,
        // "password": passwordController.text,
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
    body: Container(
      width: double.infinity,
      height: double.infinity,

      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF2E7D32),
            Color(0xFF66BB6A),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),

      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [

              const SizedBox(height: 30),

              const Icon(
                Icons.agriculture,
                size: 90,
                color: Colors.white,
              ),

              const SizedBox(height: 15),

              const Text(
                "Harvester Connect",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                "Create Your Account",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 35),

              Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20),
                ),

                child: Padding(
                  padding:
                      const EdgeInsets.all(20),

                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                          
                            TextFormField(
  controller: nameController,

  decoration: InputDecoration(
    labelText: "Full Name",
    prefixIcon: const Icon(
      Icons.person,
      color: Colors.green,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),

  validator: (value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your name";
    }
    return null;
  },
),
                          
                            const SizedBox(height: 20),
                          
                            TextFormField(
  controller: phoneController,
  keyboardType: TextInputType.phone,
  maxLength: 10,

  decoration: InputDecoration(
    labelText: "Phone Number",
    prefixIcon: const Icon(
      Icons.phone,
      color: Colors.green,
    ),
    counterText: "",
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),

  validator: (value) {

    if (value == null || value.trim().isEmpty) {
      return "Please enter phone number";
    }

    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return "Phone number must be 10 digits";
    }

    return null;
  },
),
                          
                            const SizedBox(height: 20),
                          
                            DropdownButtonFormField<
                                String>(
                              value: selectedRole,
                          
                              decoration:
                                  InputDecoration(
                                labelText:
                                    "Select Role",
                                prefixIcon:
                                    const Icon(
                                  Icons.work,
                                  color:
                                      Colors.green,
                                ),
                                border:
                                    OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                    12,
                                  ),
                                ),
                              ),
                          
                              items: const [
                          
                                DropdownMenuItem(
                                  value:
                                      "FARMER",
                                  child: Text(
                                      "🌾 Farmer"),
                                ),
                          
                                DropdownMenuItem(
                                  value:
                                      "OWNER",
                                  child: Text(
                                      "🚜 Machine Owner"),
                                ),
                              ],
                          
                              onChanged: (value) {
                                setState(() {
                                  selectedRole =
                                      value!;
                                });
                              },
                            ),
                          
                            const SizedBox(height: 30),
                          
                            SizedBox(
                              width:
                                  double.infinity,
                              height: 55,
                          
                              child:
                                  ElevatedButton(
                                style:
                                    ElevatedButton
                                        .styleFrom(
                                  backgroundColor:
                                      Colors.green,
                                  foregroundColor:
                                      Colors.white,
                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                      12,
                                    ),
                                  ),
                                ),
                          
                                onPressed: () {
                          
                                  if (_formKey.currentState!.validate()) {
    registerUser();
  }
                                },
                          
                                child: const Text(
                                  "Register",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),
                              ),
                            ),
                          
                            const SizedBox(height: 15),
                          
                            TextButton(
                              onPressed: () {
                          
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const LoginScreen(),
                                  ),
                                );
                          
                              },
                          
                              child: const Text(
                                "Already have an account? Login",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
  }
