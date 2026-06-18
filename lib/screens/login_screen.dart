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
    final password = passwordController.text.trim();

    final response = await http.post(
      Uri.parse(
        "http://127.0.0.1:8001/api/auth/login?phone=$phone&password=$password",
      ),
    );

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);
      print("*********");
      int userId = data["user_id"];
      
      String token = data["access_token"];

      final role = data["role"];

      final prefs =
    await SharedPreferences.getInstance();

await prefs.setInt(
  "userId",
  data["user_id"],
);

await prefs.setString(
  "role",
  data["role"],
);

if (role == "FARMER") {

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => FarmerMainScreen(userId: userId,),
    ),
  );

} else if (role == "OWNER") {

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => OwnerMainScreen(
      userId: userId,
    ),
    ),
  );

}

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid Login"),
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
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: login,
                child: const Text("Login"),
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
    "Don't have an account? Register",
  ),
),

          ],
        ),
      ),
    );
  }
}