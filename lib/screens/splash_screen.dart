import 'package:flutter/material.dart';
import 'package:harvester_connect_mvp/screens/farmer_main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';

import 'owner_main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
  final prefs = await SharedPreferences.getInstance();

  bool isLoggedIn =
      prefs.getBool("isLoggedIn") ?? false;

  int? userId = prefs.getInt("userId");
  String? role = prefs.getString("role");

  if (isLoggedIn &&
      userId != null &&
      role != null) {

    if (role == "FARMER") {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              FarmerMainScreen(
                userId: userId,
              ),
        ),
      );

    } else {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              OwnerMainScreen(
                userId: userId,
              ),
        ),
      );
    }

  } else {

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const LoginScreen(),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.green.shade700,

      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: const [

            Icon(
              Icons.agriculture,
              size: 120,
              color: Colors.white,
            ),

            SizedBox(height: 20),

            Text(
              "Harvester Connect",
              style: TextStyle(
                fontSize: 32,
                fontWeight:
                    FontWeight.bold,
                color: Colors.white,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "Connecting Farmers & Harvester Owners",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),

            SizedBox(height: 30),

            CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}