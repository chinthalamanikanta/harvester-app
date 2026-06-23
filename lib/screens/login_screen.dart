import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:harvester_connect_mvp/screens/farmer_main_screen.dart';
import 'package:harvester_connect_mvp/screens/owner_dashboard_screen.dart';
import 'package:harvester_connect_mvp/screens/owner_main_screen.dart';
import 'package:http/http.dart' as http;
import 'role_selection_screen.dart';
import 'register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> login() async {

  final phone = phoneController.text.trim();

  if (phone.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Please enter phone number",
        ),
      ),
    );
    return;
  }

  if (!RegExp(r'^[0-9]{10}$').hasMatch(phone)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Enter valid 10 digit phone number",
        ),
      ),
    );
    return;
  }

  final response = await http.post(
    Uri.parse(
      "https://harvester-backend-5lcq.onrender.com/api/auth/login?phone=$phone",
    ),
  );

  if (response.statusCode == 200) {

    final data = jsonDecode(response.body);
    

    int userId = data["user_id"];
    String role = data["role"];

    final prefs = await SharedPreferences.getInstance();

await prefs.setInt("userId", userId);
await prefs.setString("role", role);
await prefs.setBool("isLoggedIn", true);

    if (role == "FARMER") {

      Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
    builder: (_) => FarmerMainScreen(
      userId: userId,
    ),
  ),
  (route) => false,
);

    } else if (role == "OWNER") {

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => OwnerMainScreen(
            userId: userId,
          ),
        ), (route)=> false,
      );
    }

  } else {

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Phone number not registered",
        ),
      ),
    );
  }
}

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      width: double.infinity,
      height: double.infinity,

      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.green.shade700,
            Colors.green.shade400,
          ],
        ),
      ),

      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              children: [

                const SizedBox(height: 40),

                Container(
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),

                  child: const Icon(
                    Icons.agriculture,
                    size: 80,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Harvester Connect",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Connecting Farmers & Machine Owners",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 40),

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

                        const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 25),

                        TextField(
                          controller:
                              phoneController,
                          keyboardType:
                              TextInputType.phone,
                          maxLength: 10,

                          decoration:
                              InputDecoration(
                            labelText:
                                "Phone Number",

                            prefixIcon:
                                const Icon(
                              Icons.phone,
                              color:
                                  Colors.green,
                            ),

                            border:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                12,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          height: 55,

                          child:
                              ElevatedButton(
                            onPressed: login,

                            style:
                                ElevatedButton
                                    .styleFrom(
                              backgroundColor:
                                  Colors.green,

                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  12,
                                ),
                              ),
                            ),

                            child:
                                const Text(
                              "Login",
                              style:
                                  TextStyle(
                                fontSize:
                                    18,
                                color: Colors
                                    .white,
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
                                    const RegisterScreen(),
                              ),
                            );
                          },

                          child: const Text(
                            "New User? Register Here",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  "🌾 Farmers • 🚜 Harvesters • 📍 Easy Booking",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
  }
